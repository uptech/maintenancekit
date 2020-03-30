//
//  Mode.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

public struct Mode: Codable {
    public let upgrade: Upgrade?
    public let maintenance: Maintenance
}
