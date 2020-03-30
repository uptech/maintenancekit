//
//  File 2.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

public struct Platform: Codable {
    enum CodingKeys: String, CodingKey {
        case type = "platform"
        case latestVersion = "latest_version"
        case latestBuild = "latest_build_number"
        case minimumVersion = "minimum_version"
        case minimumBuild = "minimum_build_number"
        case store = "store_url"
        case requiresUpdate = "requires_update"
        case message = "message"
    }
    
    public enum `Type`: String, Codable {
        case iOS = "ios"
        case android = "android"
    }
    
    public let type: Type
    public let latestVersion: Version
    public let latestBuild: Int
    public let minimumVersion: Version
    public let minimumBuild: Int
    public let store: URL
    public let requiresUpdate: Bool
    public let message: Message?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(Type.self, forKey: .type)
        self.latestVersion = try Version(from: container.decode(String.self, forKey: .latestVersion))
        self.latestBuild = try container.decode(Int.self, forKey: .latestBuild)
        self.minimumVersion = try Version(from: container.decode(String.self, forKey: .minimumVersion))
        self.minimumBuild = try container.decode(Int.self, forKey: .minimumBuild)
        self.store = try container.decode(URL.self, forKey: .store)
        self.requiresUpdate = try container.decode(Bool.self, forKey: .requiresUpdate)
        self.message = try container.decodeIfPresent(Message.self, forKey: .message)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.latestVersion.string, forKey: .latestVersion)
        try container.encode(self.latestBuild, forKey: .latestBuild)
        try container.encode(self.minimumVersion.string, forKey: .minimumVersion)
        try container.encode(self.minimumBuild, forKey: .minimumBuild)
        try container.encode(self.store, forKey: .store)
        try container.encode(self.requiresUpdate, forKey: .requiresUpdate)
        try container.encode(self.message, forKey: .message)
    }
}
