//
//  WebSocketEventWrapper.swift
//  RealSwipe
//
//  Created by Utilisateur on 18/11/2025.
//

import Foundation

enum WebSocketEventWrapper: Decodable {
    case connectedResponse
    case messageResponse(MessageResponse)
    case didDeleteConversation(UUID)
    case didCreateConversation(UUID)

    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    private enum EventType: String, Decodable {
        case connected
        case message
        case didDeleteConversation = "conversation_deleted"
        case didCreateConversation = "conversation_created"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(EventType.self, forKey: .type)
        print("toto  \(type)")
        switch type {

        case .connected:
            self = .connectedResponse

        case .message:
            let data = try container.decode(MessageResponse.self, forKey: .data)
            self = .messageResponse(data)
          
        case .didDeleteConversation:
          let data = try container.decode(WebSocketDeleteConversationResponse.self, forKey: .data)
          self = .didDeleteConversation(data.id)
          
        case .didCreateConversation:
          let data = try container.decode(WebSocketCreateConversationResponse.self, forKey: .data)
          self = .didCreateConversation(data.id)
        }
    }
}

struct WebSocketDeleteConversationResponse: Decodable {
  let id: UUID
}

struct WebSocketCreateConversationResponse: Decodable {
  let id: UUID
}
