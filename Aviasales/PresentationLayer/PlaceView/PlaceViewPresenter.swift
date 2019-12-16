//
//  PlaceViewPresenter.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 02.12.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol PlaceViewPresenterProtocol: class {
	func places(by query: String)
	func requestDeparturePlace() -> PlainPlace
}

protocol PlaceViewPresenterDelegate: class {
	func update(places: [PlainPlace])
}

class PlaceViewPresenter: NSObject {

	// MARK: - Properties

	weak var delegate: PlaceViewPresenterDelegate?

	private let placeService: PlaceServiceProtocol
	private let selector = #selector(performWithDelay(by:))

	// MARK: - Construction

	init(placeService: PlaceServiceProtocol) {
		self.placeService = placeService
	}

	// MARK: - Functions

	@objc private func performWithDelay(by query: String) {
		placeService.requestPlaces(by: query)
	}
}

extension PlaceViewPresenter: PlaceViewPresenterProtocol {
	func requestDeparturePlace() -> PlainPlace {
		let location = PlainLocation(latitude: 59.806084, longitude: 30.3083)
		return PlainPlace(location: location,
		name: "Санкт-Петербург, Россия",
		airportName: "Пулково",
		iataCode: "LED")
	}

	func places(by query: String) {
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: query)
		perform(selector, with: query, afterDelay: 0.1)
	}
}

extension PlaceViewPresenter: PlaceServiceDelegate {
	func didUpdate(places: [PlainPlace]) {
		delegate?.update(places: places)
	}
}
