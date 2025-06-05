//
//  InputProtocol.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/06/2023.
//

import Foundation

protocol InputProtocol {
  static var httpMethod: String { get }
  func enrich(request: URLRequest) throws -> URLRequest
}
