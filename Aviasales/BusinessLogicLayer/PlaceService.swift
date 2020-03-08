//
//  PlaceService.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 26.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation
import CoreLocation

protocol PlaceServiceProtocol: class {
	func requestPlaces(by query: String)
}

protocol PlaceServiceDelegate: class {
	func didUpdate(places: [PlainPlace])
}

class PlaceService {

	// MARK: - Properties

	weak var delegate: PlaceServiceDelegate?

	private let networkClient: NetworkClientProtocol

	init(networkClient: NetworkClientProtocol) {
		self.networkClient = networkClient
	}
}

extension PlaceService: PlaceServiceProtocol {
	func requestPlaces(by query: String) {
		if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			networkClient.request(by: query, onSuccess: { [weak self] data in
				guard let places = try? JSONDecoder().decode([PlainPlace].self, from: data) else {
					return
				}
				DispatchQueue.main.async {
					self?.delegate?.didUpdate(places: places)
				}
			}) { error in
				print(error.localizedDescription)
			}
		}
	}
}
