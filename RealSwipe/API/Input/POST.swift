//
//  POST.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/06/2023.
//

import Foundation

struct POST<T: Encodable & Sendable>: InputProtocol, Sendable {
  
  static var httpMethod: String { "POST" }
  var data: T
  
  func enrich(request: URLRequest) throws -> URLRequest {
    var request = request
    request.httpBody = try JSONEncoder().encode(data)
    return request
  }
}
