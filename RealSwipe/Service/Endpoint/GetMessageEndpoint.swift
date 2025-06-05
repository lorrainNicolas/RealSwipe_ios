//
//  GetMessage.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

struct GetMessageEndpoint: Endpoint {
  
  struct Message: Decodable {
    let id: String
    var message: String
  }
  struct OutputData: Decodable {
    let id: String
    let messages: [Message]
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case messages = "messages"
    }
  }
  
  let input = GET()
  
  typealias Output = [GetMessageEndpoint.OutputData]
  
  var token: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIwLjAuMC4wOjgwODAvYXV0aCIsImF1ZCI6Im1vYmlsZS1hcHAiLCJ1c2VyX2lkIjoiYjdjMjc0M2YtYTMxYS00NzY4LWEwMGUtNmFiZDZkN2FlMTcwIiwiaWF0IjoxNzQ3Njg2ODUxLCJqdGkiOiIwNjg5YmJhYy1lYzRlLTQxNjktOWJlOS0zNzE4NDZjMGQ2ZjUifQ.YFdypB54Xr4gCM2vKyfHs-Ti9po6N9gwe_c2qlsp4EU"
  
  var path: String { "conversation/" }
}
