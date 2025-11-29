//
//  UserDTO.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import Foundation

struct UserDTO {
  
  let localId: UUID
  let backendId: UUID
  let username: String
  let conversastion: UUID?
  let profileImageUrl: URL?
  
  static func map(from userModel: UserModel) -> Self {
    .init(localId: userModel.localId,
          backendId: userModel.backendId,
          username: userModel.username,
          conversastion: userModel.conversation?.localId,
          profileImageUrl: userModel.profileImage)
  }
}
