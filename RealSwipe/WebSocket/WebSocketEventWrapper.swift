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

    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    private enum EventType: String, Decodable {
        case connected
        case message
    }

    init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(EventType.self, forKey: .type)

        switch type {

        case .connected:
            self = .connectedResponse

        case .message:
            let data = try container.decode(MessageResponse.self, forKey: .data)
            self = .messageResponse(data)
        }
    }
}
