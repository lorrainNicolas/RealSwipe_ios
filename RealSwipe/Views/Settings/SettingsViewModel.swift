//
//  SettingsViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import UIKit

@MainActor
class SettingsViewModel: ObservableObject {
  
  @Published var description: String = ""
  @Published var selectedImage: UIImage?
  @Published var isUploadingImage: Bool = false
  
  let infos: [SettingsAboutMeViewModel]
  
  private let userSession: UserSession
  private let api: APIClient
  
  var name: String { userSession.user.firstName }
  
  init(userSession: UserSession, api: APIClient = APIClient()) {
    self.api = api
    self.userSession = userSession
    var info: [SettingsAboutMeViewModel] = []
    if let age = userSession.user.birthday.age {
      info.append(.init(info: .age(age)))
    }
    
    if let gender = userSession.user.gender {
      info.append(.init(info: .sexe(gender.value)))
    }
    infos = info
  }
  
  func uploadImage(oldImage: UIImage?,_ image: UIImage) {
    
    let userSession = self.userSession
    isUploadingImage = true
    Task {
      let uploaderProfileImage = UploaderProfileImage(userSession: userSession)
      do {
        try await uploaderProfileImage.upload(image: image)
      } catch {
        selectedImage = oldImage
        print(error)
      }
      
      isUploadingImage = false
    }
  }
}


