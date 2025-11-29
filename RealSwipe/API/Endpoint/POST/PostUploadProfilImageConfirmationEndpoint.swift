//
//  PostUploadProfilImageConfirmationEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/11/2025.
//

import Foundation

struct PostUploadProfilImageConfirmationEndpoint: Endpoint, TokenHandler {
  
  struct InputData: Encodable, Sendable {
    let profileImageId: UUID
    
    enum CodingKeys : String, CodingKey {
        case profileImageId = "profile_image_id"
    }
  }
  
  typealias Output = UserResponse
  
  let input: POST<InputData>
  
  
  let token: String
  
  var path: String { "user/image/upload/confirmation" }
}
