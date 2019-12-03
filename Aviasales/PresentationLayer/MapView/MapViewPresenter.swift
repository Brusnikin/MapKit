//
//  MapViewPresenter.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 02.12.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation
import MapKit

protocol MapViewPresenterProtocol: class {
	func requestAnnotations(with places: [PlainPlace]) -> [PlaceAnnotation]
	func requestGeodesicPolyline(with places: [PlainPlace]) -> MKGeodesicPolyline?
	func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection
}

class MapViewPresenter: MapViewPresenterProtocol {
	func requestAnnotations(with places: [PlainPlace]) -> [PlaceAnnotation] {
		if places.isEmpty { return [] }
		return places.map { PlaceAnnotation(place: $0) }
	}

	func requestGeodesicPolyline(with places: [PlainPlace]) -> MKGeodesicPolyline? {
		if places.isEmpty { return nil }
		var coordinates = places.map { $0.location.coordinate }
		return MKGeodesicPolyline(coordinates: &coordinates, count: coordinates.count)
	}

	func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
		let x = destinationPoint.x - sourcePoint.x
		let y = destinationPoint.y - sourcePoint.y
		return atan2(y, x)
	}
}
