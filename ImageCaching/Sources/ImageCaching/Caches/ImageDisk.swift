//
//  ImageDisk.swift
//  ImageCaching
//
//  Created by Utilisateur on 28/11/2025.
//

import UIKit

protocol ImageDiskProtocol: Sendable {
  func get(from key: String) async throws -> (image: UIImage, data: Data)
  func save(from key: String, data: Data) async throws
}

actor ImageDisk: ImageDiskProtocol {

  enum Error: Swift.Error {
    case noImage
    case cacheDiskDirectoryPathError
    case cacheDiskDirectoryCreationFailed
  }

  private enum Constants {
    static let maxDayInCache: Int = 30
  }

  private let fileManager: FileManager
  private let cacheDiskDirectoryPath = NSSearchPathForDirectoriesInDomains(
    .cachesDirectory,
    .userDomainMask,
    true
  ).first.map { $0.appending("/RealSwipeImageCache") }

  init() {
    self.fileManager = FileManager.default
    Task {
      await clear()
    }
  }

  func get(from key: String) async throws -> (image: UIImage, data: Data) {
    let imagePath = try diskImagePath(from: key)
    guard fileManager.fileExists(atPath: imagePath),
          let nsdata = NSData(contentsOfFile: imagePath),
          let image = UIImage(contentsOfFile: imagePath) else { throw Error.noImage }

    return (image, Data(referencing: nsdata))
  }

  func save(from key: String, data: Data) async throws {
    let path = try diskImagePath(from: key)
    guard let cacheDiskDirectoryPath else {
      throw Error.cacheDiskDirectoryPathError
    }

    try createCacheDiskDirectoryIfNeeded(at: cacheDiskDirectoryPath)
    fileManager.createFile(atPath: path, contents: data, attributes: nil)
  }
}

private extension ImageDisk {

  func diskImagePath(from key: String) throws -> String {
    guard let cacheDiskDirectoryPath else {
      throw Error.cacheDiskDirectoryPathError
    }
    let name = diskImageName(from: key)

    return cacheDiskDirectoryPath.appending("/\(name)")
  }

  func diskImageName(from key: String) -> String {
    let separator = String.SlugSeparator.dash
    return key
      .replacingOccurrences(of: "/", with: separator.rawValue)
      .convertedToSlug(separator: separator)
  }

  func createCacheDiskDirectoryIfNeeded(at path: String) throws {
    let fileManager = FileManager.default
    guard fileManager.fileExists(atPath: path) == false else { return }

    do {
      try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    } catch {
      throw Error.cacheDiskDirectoryCreationFailed
    }
  }

  func clear() {
    do {
      guard let cacheDiskDirectoryURL = cacheDiskDirectoryPath.flatMap(URL.init) else { return }
      let items = try fileManager.contentsOfDirectory(at: cacheDiskDirectoryURL,
                                                      includingPropertiesForKeys: nil)
      for item in items {
        guard let fileAttributes = try? fileManager.attributesOfItem(atPath: item.path),
              let creationDate = fileAttributes[.creationDate] as? Date else { return }
        let maxDayInCacheInSecondes = TimeInterval(Constants.maxDayInCache * 24 * 60 * 60)
        let timeIntervalSinceNow = Date().timeIntervalSince(creationDate)
        if timeIntervalSinceNow > maxDayInCacheInSecondes {
          try? fileManager.removeItem(at: item)
        }
      }
    } catch {}
  }
}
