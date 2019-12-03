//
//  MockNetworkClient.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 28.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Aviasales

class MockNetworkClient: XCTestCase, NetworkClientProtocol {

	private(set) var places: [PlainPlace]?

	func request(by query: String, onSuccess: @escaping Success, onFailure: @escaping Failure) {
		let waiter = expectation(description: "Loading places")

		guard let data = try? JSONEncoder().encode(places) else {
			XCTFail("Failed to encode places data")
			return
		}

		onSuccess(data)

		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			waiter.fulfill()
		}

		waitForExpectations(timeout: 1.0)
	}

	func add(places: [PlainPlace]) {
		self.places = places
	}
}
