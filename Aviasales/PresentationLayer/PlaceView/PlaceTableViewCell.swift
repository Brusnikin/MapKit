//
//  PlaceTableViewCell.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 26.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

	// MARK: - Properties

	private let iataLabel = UILabel()

	// MARK: - Construction

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

		selectionStyle = .none

		if #available(iOS 13.0, *) {
			textLabel?.backgroundColor = .systemBackground
			detailTextLabel?.backgroundColor = .systemBackground
			iataLabel.backgroundColor = .systemBackground
		} else {
			textLabel?.backgroundColor = .white
			detailTextLabel?.backgroundColor = .white
			iataLabel.backgroundColor = .white
		}
		accessoryView = iataLabel
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension PlaceTableViewCell: Configurable, ReusableView {
	typealias DataType = PlainPlace

	func configure(_ place: PlainPlace) {
		textLabel?.text = place.airportName
		detailTextLabel?.text = place.name
		iataLabel.text = place.iataCode
		iataLabel.sizeToFit()
	}
}
