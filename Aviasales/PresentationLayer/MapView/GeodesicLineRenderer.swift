//
//  GeodesicLineRenderer.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 03.12.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation
import MapKit

class GeodesicLineRenderer: MKPolylineRenderer {

	// MARK: - Properties

	private let geodesicLineOverlay: MKGeodesicPolyline

	// MARK: - Construction

	init(overlay: MKGeodesicPolyline) {
		geodesicLineOverlay = overlay
		super.init(overlay: geodesicLineOverlay)
		alpha = 0.5
		lineCap = .round
		lineWidth = 2.0
		strokeColor = .systemBlue
		lineDashPattern = [2, 3];
	}
}
