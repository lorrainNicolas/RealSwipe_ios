//
//  APIClient.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation

protocol TokenHandler {
  var token: String { get }
}

protocol Endpoint: Sendable {
  associatedtype Input: InputProtocol
  var input: Input { get }
  
  associatedtype Output: Decodable & Sendable

  var path: String { get }
}



protocol APIClientProtocol: Sendable {
  func sendRequest<T: Endpoint>(to endpoint: T) async throws -> T.Output
}

final class APIClient: APIClientProtocol  {
  
  enum Error: Swift.Error {
    case invalidUrl
    case invalidResponse
    case requestFailed
  }
  
  private let baseURL: String = "https://realswipe.onrender.com"
  
  func sendRequest<T: Endpoint>(to endpoint: T) async throws -> T.Output {
    guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint.path) else { throw Error.invalidUrl }
    
    var request = try endpoint.input.enrich(request: URLRequest(url: url))
    request.httpMethod = T.Input.httpMethod
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let tokenHandler = endpoint as? TokenHandler {
      request.addValue("Bearer \(tokenHandler.token)", forHTTPHeaderField: "Authorization")
    }
   
    print("request \(request.url?.absoluteString ?? "")")
    do {
      let data = try await URLSession.shared.data(for: request)
      guard let httpResponse = data.1 as? HTTPURLResponse else { throw Error.invalidResponse }
      guard (200...299).contains(httpResponse.statusCode) else {
        print("ERROR requestFailed \(String(data: data.0, encoding: .utf8) ?? "")")
        throw Error.requestFailed
      }
      
      return try JSONDecoder().decode(T.Output.self, from: data.0)
    } catch {
    
      throw error
    }
  }
}
