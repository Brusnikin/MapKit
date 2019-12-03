//
//  CrossCurrencyNetworkClient.swift
//  Aviasales
//
//  Created by Blashkin Georgiy on 26.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    typealias Success = (_ data: Data) -> Void
    typealias Failure = (_ error: Error) -> Void

	func request(by query: String, onSuccess: @escaping Success, onFailure: @escaping Failure)
}

class NetworkClient: NSObject {

	// MARK: - Properties

	private lazy var session: URLSession = {
		let configuration = URLSessionConfiguration.default
		configuration.requestCachePolicy = .returnCacheDataElseLoad
		return URLSession(configuration: configuration)
	}()

	private var dataTask: URLSessionDataTask?

	// MARK: - Functions

	private func createRequest(query: String) -> URLRequest {
		var urlComponents = URLComponents()
		urlComponents.scheme = "http"
		urlComponents.host = "places.aviasales.ru"
		urlComponents.path = "/places"
		let termQuery = URLQueryItem(name: "term", value: query)
		let localeQuery = URLQueryItem(name: "locale", value: Locale.current.languageCode ?? "ru")
		urlComponents.queryItems = [termQuery, localeQuery]
		guard let url = urlComponents.url else { fatalError("URL could not be configured.") }
		return URLRequest(url: url)
	}
}

extension NetworkClient: URLSessionTaskDelegate {
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		print(task.state)
	}
}

extension NetworkClient: NetworkClientProtocol {
	func request(by query: String, onSuccess: @escaping Success, onFailure: @escaping Failure) {
		dataTask?.cancel()
		let request = createRequest(query: query)
		dataTask = session.dataTask(with: request) { (data, response, error) in
			if let data = data { onSuccess(data) }
			if let error = error { onFailure(error) }
		}
		dataTask?.resume()
	}
}
