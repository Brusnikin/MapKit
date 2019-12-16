//
//  PlaceViewController.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 25.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {

	// MARK: - Properties

	private let presenter: PlaceViewPresenterProtocol
	private let tableView = UITableView()
	private lazy var tableAdapter = PlaceTableAdapter(tableView: tableView)
	private let search = UISearchController(searchResultsController: nil)
	
	private lazy var spinner: UIActivityIndicatorView = {
		let frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 50))
		let spinner = UIActivityIndicatorView(frame: frame)
		spinner.color = .systemGray
		return spinner
	}()

	// MARK: - Construction

	init(presenter: PlaceViewPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func loadView() {
		view = tableView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableAdapter.delegate = self
		tableView.delegate = tableAdapter
		tableView.dataSource = tableAdapter
		tableView.tableFooterView = spinner

		search.searchBar.showsCancelButton = true
		search.searchResultsUpdater = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Город, страна или аэропорт"
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		search.hidesNavigationBarDuringPresentation = false
		definesPresentationContext = true

		if #available(iOS 11.0, *) {
			navigationItem.searchController = search
		} else {
			navigationItem.titleView = search.searchBar
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		search.isActive = true
		search.searchBar.becomeFirstResponder()
	}
}

extension PlaceViewController: UISearchResultsUpdating, UISearchBarDelegate {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }

		if text.isEmpty {
			tableAdapter.show(places: [])
			spinner.stopAnimating()
		} else {
			presenter.places(by: text)
			spinner.startAnimating()
		}
	}
}

extension PlaceViewController: PlaceTableAdapterDelegate {
	func didSelect(destination: PlainPlace) {
		let departure = presenter.requestDeparturePlace()
		if destination.iataCode == departure.iataCode {
			return
		}

		let presenter = MapViewPresenter()
		let mapViewController = MapViewController(presenter: presenter)
		mapViewController.title = "\(departure.iataCode)-\(destination.iataCode)"
		mapViewController.display(place: departure, destination: destination)
		navigationController?.pushViewController(mapViewController, animated: true)
	}
}

extension PlaceViewController: PlaceViewPresenterDelegate {
	func update(places: [PlainPlace]) {
		tableAdapter.show(places: places)
		spinner.stopAnimating()
	}
}
