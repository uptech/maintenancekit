//
//  Maintenance.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

public struct Maintenance: Codable {
    enum CodingKeys: String, CodingKey {
        case isActive = "active"
        case isScheduled = "scheduled"
        case isOffline = "offline"
        case startDate = "start_date"
        case endDate = "end_date"
        case message = "message"
    }
    
    public let isActive: Bool
    public let isScheduled: Bool
    public let isOffline: Bool
    public let startDate: Date?
    public let endDate: Date?
    public let message: Message?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.isScheduled = try container.decode(Bool.self, forKey: .isScheduled)
        self.isOffline = try container.decode(Bool.self, forKey: .isOffline)
        self.message = try container.decodeIfPresent(Message.self, forKey: .message)
        self.startDate = try? container.decodeIfPresent(Date.self, forKey: .startDate)
        self.endDate = try? container.decodeIfPresent(Date.self, forKey: .endDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.isScheduled, forKey: .isScheduled)
        try container.encode(self.isOffline, forKey: .isOffline)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.message, forKey: .message)
    }
}
