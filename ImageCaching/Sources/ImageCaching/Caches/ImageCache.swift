//
//  ImagCache.swift
//  ImageCaching
//
//  Created by Utilisateur on 28/11/2025.
//

import UIKit

protocol ImageCacheProtocol: Sendable {
  func get(from key: String) async throws -> UIImage
  func save(from key: String, image: UIImage, cost: Int) async
}

actor ImageCache: ImageCacheProtocol {
  enum Constants {
    static let maxImage = 150
  }
  enum Error: Swift.Error {
    case noImage
  }

  private let cache: NSCache<NSString, UIImage> = {
    let cache = NSCache<NSString, UIImage>()
    cache.name = "RealSwipeCache"
    cache.totalCostLimit = Constants.maxImage * 1024 * 1024
    return cache
  }()

  func get(from key: String) async throws -> UIImage {
    if let image = cache.object(forKey: key as NSString) {
      return image
    } else {
      throw Error.noImage
    }
  }

  func save(from key: String, image: UIImage, cost: Int) async {
    cache.setObject(image, forKey: key as NSString, cost: cost)
  }
}
