//
//  PlaneAnnotationView.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 28.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit
import MapKit

class PlaneAnnotationView: MKAnnotationView, ReusableView {
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		image = #imageLiteral(resourceName: "plane.pdf")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
