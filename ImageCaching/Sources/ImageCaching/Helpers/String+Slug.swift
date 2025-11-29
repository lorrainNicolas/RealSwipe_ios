//
//  String+Slug.swift
//  ImageCaching
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

extension String {
  
  enum SlugSeparator: String {
    case dash = "-"
    case underscore = "_"
  }

  private static let slugSafeCharacters = "0123456789abcdefghijklmnopqrstuvwxyz./-|~"

  func convertedToSlug(separator: SlugSeparator = .underscore) -> String {
    return self
      .applyingTransform(StringTransform("Any-Latin; Latin-ASCII"), reverse: false)? // æ -> ae
      .applyingTransform(.stripDiacritics, reverse: false)? // é -> e
      .lowercased() // A -> a
      .split(whereSeparator: { !String.slugSafeCharacters.contains($0) }) // "🖤a:/a.,a;$-a" -> ["a", "/a.", "a", "-a"]
      .joined(separator: separator.rawValue) // ["a", "/a.", "a", "-a"] -> "a_/a._a_-a"
    ?? ""
  }
}
