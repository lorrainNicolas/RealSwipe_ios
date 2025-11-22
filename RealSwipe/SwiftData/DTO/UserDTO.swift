//
//  UserDTO.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import Foundation

struct UserDTO {
  
  let id: UUID
  let backendId: UUID
  let username: String
  let conversastion: UUID?
  
  static func map(from userModel: UserModel) -> Self {
    .init(id: userModel.id,
          backendId: userModel.backendId,
          username: userModel.username,
          conversastion: userModel.conversation?.id)
  }
}
