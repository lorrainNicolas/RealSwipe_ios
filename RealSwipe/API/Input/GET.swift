//
//  GET.swift
//  RealSwipe
//
//  Created by Utilisateur on 22/11/2025.
//

import Foundation

struct GET: InputProtocol {
  static var httpMethod: String { "GET" }
  
  func enrich(request: URLRequest) throws -> URLRequest {
    return request
  }
}
