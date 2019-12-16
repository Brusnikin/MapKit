//
//  MapViewController.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 26.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerProtocol {
	func display(place departure: PlainPlace, destination: PlainPlace)
}

class MapViewController: UIViewController {

	// MARK: - Properties

	private let presenter: MapViewPresenterProtocol
	private let mapView = MKMapView()
	private lazy var mapViewAdapter = MapViewAdapter(mapView: mapView)
	private var flightPath: MKGeodesicPolyline?
	private var planeAnnotation = MKPointAnnotation()
	private var displayLink: CADisplayLink?
	private var places = [PlainPlace]()

	private var planeStep = 1
	private var planePosition = 0
	private let planeSpeed = 60

	// MARK: - Construction

	init(presenter: MapViewPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func loadView() {
		view = mapView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		mapViewAdapter.delegate = self
		mapView.delegate = mapViewAdapter
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		displayLink?.isPaused = true
		displayLink?.invalidate()
	}

	// MARK: - Functions

	private func showPlaneAnimation() {
		displayLink = CADisplayLink(target: self, selector: #selector(updatePlanePosition))
		displayLink?.add(to: RunLoop.main, forMode: .common)
	}

	@objc private func updatePlanePosition() {
		guard let geodesicPolyline = flightPath else {
			return
		}

		let route = geodesicPolyline.pointCount
		let points = geodesicPolyline.points()

		guard route != 0, planePosition + planeStep <= route else {
			planePosition = 0
			return
		}

		let ratio = route / planeSpeed
		if ratio > planeSpeed {
			planeStep = Int(Double(ratio).squareRoot())
		}

		let prevPosition = points[planePosition]
		planePosition += planeStep
		let nextPosition = points[planePosition]

		planeAnnotation.coordinate = nextPosition.coordinate

		// Plane direction
		let planeDirection = presenter.directionBetweenPoints(sourcePoint: prevPosition, nextPosition)
		let planeAnnotationView = mapView.view(for: planeAnnotation)
		planeAnnotationView?.transform = mapView.transform.rotated(by: CGFloat(planeDirection))
	}
}

extension MapViewController: MapViewControllerProtocol {
	func display(place departure: PlainPlace, destination: PlainPlace) {
		self.places = [departure, destination]
	}

	func addAnnotations() {
		let annotations = presenter.requestAnnotations(with: places)
		mapView.addAnnotations(annotations)
		mapView.addAnnotation(planeAnnotation)
		mapView.selectAnnotation(planeAnnotation, animated: false)
		if let geodesicPolyline = presenter.requestGeodesicPolyline(with: places) {
			mapView.addOverlay(geodesicPolyline)
			flightPath = geodesicPolyline
		}
		mapViewAdapter.show(annotations: annotations, animated: false)
	}
}

extension MapViewController: MapViewAdapterDelegate {
	func mapViewDidFinishRenderingMap() {
		addAnnotations()
		showPlaneAnimation()
	}
}
