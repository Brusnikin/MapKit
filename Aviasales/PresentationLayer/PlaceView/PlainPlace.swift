//
//  PlainPlace.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 26.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation
import CoreLocation

struct PlainLocation: Codable {
	var latitude: Double
	var longitude: Double
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2DMake(latitude, longitude)
	}

	private enum CodingKeys: String, CodingKey {
		case latitude = "lat"
		case longitude = "lon"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(latitude, forKey: .latitude)
		try container.encode(longitude, forKey: .longitude)
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		latitude = try container.decode(Double.self, forKey: .latitude)
		longitude = try container.decode(Double.self, forKey: .longitude)
	}

	init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
}

struct PlainPlace: Codable {
	var location: PlainLocation
	var name: String
	var airportName: String?
	var iataCode: String

	private enum CodingKeys: String, CodingKey {
		case location
		case name
		case airportName = "airport_name"
		case iataCode = "iata"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(location, forKey: .location)
		try container.encode(name, forKey: .name)
		try container.encode(airportName, forKey: .airportName)
		try container.encode(iataCode, forKey: .iataCode)
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		location = try container.decode(PlainLocation.self, forKey: .location)
		name = try container.decode(String.self, forKey: .name)
		airportName = try container.decodeIfPresent(String.self, forKey: .airportName)
		iataCode = try container.decode(String.self, forKey: .iataCode)
	}

	init(location: PlainLocation, name: String, airportName: String?, iataCode: String) {
		self.location = location
		self.name = name
		self.airportName = airportName
		self.iataCode = iataCode
	}
}
