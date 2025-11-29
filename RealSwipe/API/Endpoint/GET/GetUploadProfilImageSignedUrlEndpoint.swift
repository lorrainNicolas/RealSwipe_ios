//
//  GetUploadProfilImageSignedUrlEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/11/2025.
//

import Foundation

struct GetUploadProfilImageSignedUrlEndpoint: Endpoint, TokenHandler {
  
  struct OutputData: Decodable {
    let signedUrl: URL
    let imageId: UUID
    
    
    enum CodingKeys : String, CodingKey {
        case signedUrl = "signed_url"
        case imageId = "image_id"
    }
  }
  
  let input = GET()
  
  typealias Output = Self.OutputData
  
  let token: String
  
  let path: String
  
  init(token: String) {
    self.token = token
    self.path = "user/image/upload/request"
  }
}


