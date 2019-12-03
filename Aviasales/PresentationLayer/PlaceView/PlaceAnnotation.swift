//
//  PlaceAnnotation.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 29.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {

	// MARK: - Properties

	private(set) var place: PlainPlace

	var coordinate: CLLocationCoordinate2D { return place.location.coordinate }
    var title: String? {  return place.iataCode }

	// MARK: - Construction

	init(place: PlainPlace) {
		self.place = place
		super.init()
	}
}
