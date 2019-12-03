//
//  MockPlaceServiceDelegate.swift
//  AviasalesTests
//
//  Created by Blashkin Georgiy on 02.12.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Aviasales

class MockPlaceServiceDelegate: XCTestCase, PlaceServiceDelegate {

	private(set) var places: [PlainPlace]?

	func didUpdate(places: [PlainPlace]) {
		self.places = places
	}
}
