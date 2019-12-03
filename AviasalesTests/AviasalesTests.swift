//
//  AviasalesTests.swift
//  AviasalesTests
//
//  Created by Blashkin Georgiy on 25.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Aviasales

class AviasalesTests: XCTestCase {
    func testPlaceService() {
		let places = generatedPaces()
		let networkClient = MockNetworkClient()
		networkClient.add(places: places)
		let delegate = MockPlaceServiceDelegate()
		let service = PlaceService(networkClient: networkClient)
		service.delegate = delegate
		service.requestPlaces(by: "SVO")
		service.requestPlaces(by: "LED")
		
		XCTAssertFalse(places.isEmpty)
		XCTAssertNotNil(delegate.places)
		XCTAssertFalse(delegate.places?.isEmpty ?? true)

		XCTAssertEqual(places[0].iataCode, delegate.places?[0].iataCode)
		XCTAssertEqual(places[0].location.latitude, delegate.places?[0].location.latitude)
		XCTAssertEqual(places[0].location.longitude, delegate.places?[0].location.longitude)

		XCTAssertEqual(places[1].iataCode, delegate.places?[1].iataCode)
		XCTAssertEqual(places[1].location.latitude, delegate.places?[1].location.latitude)
		XCTAssertEqual(places[1].location.longitude, delegate.places?[1].location.longitude)
    }

	func testEmptyQuery() {
		let networkClient = MockNetworkClient()
		networkClient.add(places: [])
		let delegate = MockPlaceServiceDelegate()
		let service = PlaceService(networkClient: networkClient)
		service.delegate = delegate

		service.requestPlaces(by: "")
		XCTAssertNil(delegate.places)
	}

	private func generatedPaces() -> [PlainPlace] {
		let location = PlainLocation(latitude: 50, longitude: 30)
		return [PlainPlace(location: location,
						   name: "test",
						   airportName: "test",
						   iataCode: "SVO"),
				PlainPlace(location: location,
						   name: "test",
						   airportName: nil,
						   iataCode: "LED")]
	}
}
