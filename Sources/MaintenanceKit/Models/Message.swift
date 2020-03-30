//
//  File.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

public struct Message: Codable {
    public let title: String
    public let body: String
}

extension Message: Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.title == rhs.title &&
            lhs.body == rhs.body
    }
}
