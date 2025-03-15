//
//  BaseAPIService.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/9/25.
//

import Foundation
import Core
import UIKit

open class BaseAPIService {

    open var baseURL: String { fatalError("baseURL must be overridden") }
    open var apiKey: String { fatalError("apiKey must be overridden") }

    private let decoder: JSONDecoder

    public init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func buildURL<P: APIPath>(
        for path: P,
        customParams: [CustomQueryParameter] = []
    ) throws -> URL {
        var components = URLComponents(string: baseURL + path.path)
        var queryItems = path.queryParams ?? []
        if customParams.contains(.apiKey) {
            queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        }
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw CoreError.networkError(.invalidURL)
        }
        return url
    }

    /// Generic method to fetch and decode data from any API
    func fetchData<T: Decodable, P: APIPath>(
        from path: P,
        customParams: [CustomQueryParameter] = [],
        customHeaders: [String: String] = [:]
    ) async throws -> T {
        let url = try buildURL(for: path, customParams: customParams)

        var request = URLRequest(url: url)
        request.httpMethod = path.httpMethod.rawValue
        request.allHTTPHeaderFields = customHeaders
        request.cachePolicy = .useProtocolCachePolicy

        let (data, _) = try await URLSession.shared.data(for: request)
        #if DEBUG
        if let string = data.prettyPrintedJSONString {
            print("DEBUG50\nURL: \(url)\nPath: \(path.path)\nJSON: \(string)\\")
        }
        #endif
        return try decoder.decode(T.self, from: data)
    }

    // Fetch UIImage
    func fetchImage<P: APIPath>(
        from path: P,
        customParams: [CustomQueryParameter] = [],
        customHeaders: [String: String] = [:]
    ) async throws -> UIImage? {
        let url = try buildURL(for: path, customParams: customParams)
//        let url = URL(string: "https://muscle-group-image-generator.p.rapidapi.com/getImage?muscleGroups=biceps%2Cchest%2Chamstring&color=200%2C100%2C80&transparentBackground=0")!

        var request = URLRequest(url: url)
        request.httpMethod = path.httpMethod.rawValue
        request.allHTTPHeaderFields = customHeaders
        request.cachePolicy = .useProtocolCachePolicy

        let (data, _) = try await URLSession.shared.data(for: request)

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("muscle_image.png")
        try? data.write(to: tempURL)
        print("Saved image at:", tempURL)

        return UIImage(data: data)
    }
}
