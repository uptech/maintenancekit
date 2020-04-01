//
//  Version.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

public struct Version: Codable {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public var string: String {
        return "\(self.major).\(self.minor).\(self.patch)"
    }
    
    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public init(from string: String) {
        let values = string.components(separatedBy: ".")
        switch values.count {
        case 3:
            self.major = Int(values[0]) ?? 0
            self.minor = Int(values[1]) ?? 0
            self.patch = Int(values[2]) ?? 0
            
        case 2:
            self.major = Int(values[0]) ?? 0
            self.minor = Int(values[1]) ?? 0
            self.patch = 0
            
        case 1:
            self.major = Int(values[0]) ?? 0
            self.minor = 0
            self.patch = 0
            
        default:
            self.major = 0
            self.minor = 0
            self.patch = 0
        }
    }
}

extension Version: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension Version: Equatable, Comparable {
    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major &&
            lhs.minor == rhs.minor &&
            lhs.patch == rhs.patch
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        return lhs.string.compare(rhs.string, options: .numeric) == .orderedAscending
    }
    
    public static func <= (lhs: Version, rhs: Version) -> Bool {
        return lhs.major <= rhs.major &&
            lhs.minor <= rhs.minor &&
            lhs.patch <= rhs.patch
    }
    
    public static func > (lhs: Version, rhs: Version) -> Bool {
        return lhs.string.compare(rhs.string, options: .numeric) == .orderedDescending
    }
    
    public static func >= (lhs: Version, rhs: Version) -> Bool {
        return lhs.major >= rhs.major &&
            lhs.minor >= rhs.minor &&
            lhs.patch >= rhs.patch
    }
}
