//
//  UploaderProfileImage.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/11/2025.
//

import UIKit
import ImageCaching

struct UploaderProfileImage {
  private let api: APIClient = APIClient()
  private let userSession: UserSession
  
  enum Failure: Error {
    case unableToResizeImage
    case unableToConvertImage
    case uploadS3Failed
    case noProfileURLInResponse
  }
  
  init(userSession: UserSession) {
    self.userSession = userSession
  }
  
 func upload(image: UIImage) async throws -> (URL,Data) {
    guard let image = await UIImageResizer().resizeToWidth(image: image, 480) else  {
      throw Failure.unableToResizeImage
    }
    
    guard let imagedata = image.jpegData(compressionQuality: 0.55) else {
      throw Failure.unableToConvertImage
    }
    
    let value = try await api.sendRequest(to: GetUploadProfilImageSignedUrlEndpoint(token: userSession.token))
    try await uploadImage(presignedUrl: value.signedUrl, imageData: imagedata)
    let user = try await api.sendRequest(to: PostUploadProfilImageConfirmationEndpoint(input: .init(data: .init(profileImageId: value.imageId)),
                                                                                       token: userSession.token))
   guard let profileUrl = user.profileImageUrl else { throw Failure.noProfileURLInResponse }
   return (profileUrl, imagedata)
  }
  
  func uploadImage(presignedUrl: URL, imageData: Data) async throws {
    var request = URLRequest(url: presignedUrl)
    request.httpMethod = "PUT"
    request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
    request.httpBody = imageData
    
    let data = try await URLSession.shared.data(for: request)
    guard let httpResponse = data.1 as? HTTPURLResponse else { throw Failure.uploadS3Failed }
    guard (200...299).contains(httpResponse.statusCode) else {
      throw Failure.uploadS3Failed
    }
  }
}
