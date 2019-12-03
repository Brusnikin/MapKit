//
//  PlaceAnnotationView.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 28.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotationView: MKAnnotationView, ReusableView {

	// MARK: - Properties

	private let textLabelSize = CGSize(width: 50.0, height: 20.0)
	private let textLabel = UILabel()
	private lazy var attributes: [NSAttributedString.Key : Any] = {
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = .center
		return [.font: UIFont.systemFont(ofSize: 10, weight: .medium),
				.foregroundColor: UIColor.systemBlue,
				.paragraphStyle: paragraph]
	}()

	// MARK: - Construction
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		let origin = CGPoint(x: center.x - textLabelSize.width / 2, y: center.y - textLabelSize.height / 2)
		textLabel.frame = CGRect(origin: origin, size: textLabelSize)
		addSubview(textLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Functions

	func configure() {
		if #available(iOS 13.0, *) {
			textLabel.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
		} else {
			textLabel.backgroundColor = UIColor.white.withAlphaComponent(0.7)
		}

		let iataCode = (annotation as? PlaceAnnotation)?.place.iataCode ?? ""
		textLabel.attributedText = NSAttributedString(string: iataCode, attributes: attributes)
		textLabel.layer.cornerRadius = textLabelSize.height / 2
		textLabel.layer.masksToBounds = true
		textLabel.layer.borderWidth = 2
		textLabel.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
	}
}
