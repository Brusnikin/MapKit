//
//  PlaceTableAdapter.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 26.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol PlaceTableAdapterProtocol: class {
	func show(places: [PlainPlace])
}

protocol PlaceTableAdapterDelegate: class {
	func didSelect(destination: PlainPlace)
}

class PlaceTableAdapter: NSObject {

	// MARK: - Properties

	weak var delegate: PlaceTableAdapterDelegate?

	private let tableView: UITableView
	private var places = [PlainPlace]()

	// MARK: - Construction

	init(tableView: UITableView) {
		tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.reuseIdentifier)
		self.tableView = tableView

		super.init()
	}
}

extension PlaceTableAdapter: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		delegate?.didSelect(destination: places[indexPath.row])
	}
}

extension PlaceTableAdapter: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		places.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier, for: indexPath) as? PlaceTableViewCell else {
			return UITableViewCell()
		}
		cell.configure(places[indexPath.row])
		return cell
	}
}

extension PlaceTableAdapter: PlaceTableAdapterProtocol {
	func show(places: [PlainPlace]) {
		self.places = places
		tableView.reloadData()
	}
}
