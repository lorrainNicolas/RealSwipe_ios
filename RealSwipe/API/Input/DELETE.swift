//
//  DELETE.swift
//  RealSwipe
//
//  Created by Utilisateur on 22/11/2025.
//

import Foundation

struct DELETE: InputProtocol {
  static var httpMethod: String { "DELETE" }
  
  func enrich(request: URLRequest) throws -> URLRequest {
    return request
  }
}
