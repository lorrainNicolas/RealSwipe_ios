// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  ImageLoader.swift
//
//
//  Created by Nlorrain on 08/07/2024.
//

import UIKit

public protocol ImageLoaderProtocol: Sendable {
  @MainActor func load(from url: URL) async throws -> UIImage
}

public actor ImageLoader: ImageLoaderProtocol {
  public enum ImageLoaderError: Error {
    case unableToConvertDataToImage
    case unableToTransformImageToData
  }
  
  public enum ImageProvider {
    case cache
    case disk
    case fetch
  }
  
  public static let shared: ImageLoaderProtocol = ImageLoader()
  
  private let urlSession: URLSession
  private let imageCache: ImageCacheProtocol
  private let imageDisk: ImageDiskProtocol
  
  private var pendingTasks = [String: Task<UIImage, Error>]()
  
  init(urlSession: URLSession = URLSession.shared,
       imageCache: ImageCacheProtocol = ImageCache(),
       imageDisk: ImageDiskProtocol = ImageDisk()) {
    self.urlSession = urlSession
    self.imageCache = imageCache
    self.imageDisk = imageDisk
  }
  
  @MainActor
  public func load(from url: URL) async throws -> UIImage {
    return try await loadTask(from: url)
  }
}

private extension ImageLoader {
  func loadTask(from url: URL) async throws -> UIImage {
    let key = buildKey(url: url)
    
    if let loadingTask = pendingTasks[key] {
      return try await loadingTask.value
    }
    
    let loadingTask = buildLoadingTask(for: key, url: url)
    pendingTasks[key] = loadingTask
    return try await loadingTask.value
  }
  
  
  func buildLoadingTask(for key: String, url: URL) -> Task<UIImage, Error> {
    
    let task = Task<UIImage, Error> {
      
      defer {
        pendingTasks.removeValue(forKey: key)
      }
      
      if let imageCache = try? await imageCache.get(from: key) {
        return imageCache
      } else if let imageDisk = try? await imageDisk.get(from: key) {
        await imageCache.save(from: key,
                              image: imageDisk.image,
                              cost: imageDisk.data.count)
        return imageDisk.image
      }
      
      let value = try await fetch(url: url)
      await saveToAllCache(from: key, image: value.image, associatedData: value.data)
      return value.image
    }
    
    return task
  }
}

private extension ImageLoader {
  
  func fetch(url: URL) async throws -> (image: UIImage, data: Data) {
    
    let (data, _) = try await urlSession.data(from: url)
    
    guard let image = UIImage(data: data) else {
      throw ImageLoaderError.unableToConvertDataToImage
    }
    
    return (image: image, data: data)
  }
  
  func saveToAllCache(from key: String, image: UIImage, associatedData data: Data) async {
    await imageCache.save(from: key, image: image, cost: data.count)
    try? await imageDisk.save(from: key, data: data)
  }
  
  func buildKey(url: URL) -> String {
    url.absoluteString
  }
}

