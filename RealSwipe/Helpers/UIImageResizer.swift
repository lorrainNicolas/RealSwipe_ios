//
//  UIImageResizer.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/11/2025.
//

import UIKit

class UIImageResizer {
  @concurrent
  func resizeToWidth(image: UIImage ,_ targetWidth: CGFloat) async ->  UIImage? {
      let originalWidth = image.size.width
      let originalHeight = image.size.height
    
      let scaleFactor = targetWidth / originalWidth
      let targetHeight = originalHeight * scaleFactor
      let newSize = CGSize(width: targetWidth, height: targetHeight)
      
      UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
      image.draw(in: CGRect(origin: .zero, size: newSize))
      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return resizedImage
  }
}
