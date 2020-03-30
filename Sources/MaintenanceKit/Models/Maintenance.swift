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
    public let startDate: Date
    public let endDate: Date
    public let message: Message?
}
