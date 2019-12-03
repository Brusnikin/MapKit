//
//  MapViewAdapter.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 30.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewAdapterProtocol: class {
	func show(annotations: [PlaceAnnotation], animated: Bool)
}

protocol MapViewAdapterDelegate: class {
	func mapViewDidFinishRenderingMap()
	func mapViewDidFinishLoadingMap()
}

class MapViewAdapter: NSObject {

	// MARK: - Properties

	weak var delegate: MapViewAdapterDelegate?

	private var didFinishRendering = false
	private var didFinishLoading = false
	private let mapView: MKMapView

	// MARK: - Construction

	init(mapView: MKMapView) {
		mapView.isRotateEnabled = false
		mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.reuseIdentifier)
		mapView.register(PlaneAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaneAnnotationView.reuseIdentifier)
		self.mapView = mapView
		super.init()
	}

	// MARK: - Functions

	private func bringPlaneAnnotationToFront() {
		if let planeAnnotation = mapView.annotations.first(where: { $0 is MKPointAnnotation }) {
			mapView.selectAnnotation(planeAnnotation, animated: false)
		}
	}
}

extension MapViewAdapter: MapViewAdapterProtocol {
	func show(annotations: [PlaceAnnotation], animated: Bool) {
		var visibleAnnotationRect: MKMapRect = .null
		let delta = 20000.0
		for annotation in annotations {
			let coordinate = annotation.coordinate
			let center = MKMapPoint(coordinate)
			let rect = MKMapRect(x: center.x - delta, y: center.y - delta, width: delta * 2, height: delta * 2)
			visibleAnnotationRect = visibleAnnotationRect.union(rect)
		}

		let edgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
		mapView.mapRectThatFits(visibleAnnotationRect, edgePadding: edgeInsets)
		mapView.setVisibleMapRect(visibleAnnotationRect, edgePadding: edgeInsets, animated: animated)
	}
}

extension MapViewAdapter: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let lineOverlay = overlay as? MKGeodesicPolyline {
			return GeodesicLineRenderer(overlay: lineOverlay)
		}
		return MKOverlayRenderer(overlay: overlay)
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation { return nil }

		if annotation is PlaceAnnotation {
			let placeAnnotationView = PlaceAnnotationView(annotation: annotation, reuseIdentifier: PlaceAnnotationView.reuseIdentifier)
			placeAnnotationView.configure()
			return placeAnnotationView
		} else {
			return PlaneAnnotationView(annotation: annotation, reuseIdentifier: PlaneAnnotationView.reuseIdentifier)
		}
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		bringPlaneAnnotationToFront()
	}

	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		bringPlaneAnnotationToFront()
	}

	func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
		if fullyRendered, !didFinishRendering {
			didFinishRendering = true

			print("mapViewDidFinishRenderingMap")
			self.delegate?.mapViewDidFinishRenderingMap()
		}
	}

	func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
		if !didFinishLoading {
			didFinishLoading = true

			print("mapViewDidFinishLoadingMap")
			self.delegate?.mapViewDidFinishLoadingMap()
		}
	}
}
