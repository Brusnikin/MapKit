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
		let location = PlainLocation(latitude: 50, longitude: 30)
		let departure = PlainPlace(location: location, name: "test", airportName: "test", iataCode: "SVO")
		let destination = PlainPlace(location: location, name: "test", airportName: "test", iataCode: "LED")

		let networkClient = MockNetworkClient()
		networkClient.add(places: [departure, destination])
		let delegate = MockPlaceServiceDelegate()
		let service = PlaceService(networkClient: networkClient)
		service.delegate = delegate
		service.requestPlaces(by: "SVO")
		service.requestPlaces(by: "LED")

		XCTAssertEqual(departure.iataCode, delegate.places?[0].iataCode)
		XCTAssertEqual(departure.location.latitude, delegate.places?[0].location.latitude)
		XCTAssertEqual(departure.location.longitude, delegate.places?[0].location.longitude)

		XCTAssertEqual(destination.iataCode, delegate.places?[1].iataCode)
		XCTAssertEqual(destination.location.latitude, delegate.places?[1].location.latitude)
		XCTAssertEqual(destination.location.longitude, delegate.places?[1].location.longitude)
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
}
