//
//  AppDelegate.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 25.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Properties

	var window: UIWindow?

	private let navigationController = UINavigationController()

	// MARK: - Lifecycle

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let networkClient = NetworkClient()
		let placeService = PlaceService(networkClient: networkClient)
		let presenter = PlaceViewPresenter(placeService: placeService)
		placeService.delegate = presenter
		let placeViewController = PlaceViewController(presenter: presenter)
		placeViewController.title = "Поиск"
		presenter.delegate = placeViewController
		navigationController.pushViewController(placeViewController, animated: false)
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController

		if #available(iOS 13.0, *) {
			window?.backgroundColor = .systemBackground
		} else {
			window?.backgroundColor = .white
		}

		window?.makeKeyAndVisible()

		return true
	}
}

