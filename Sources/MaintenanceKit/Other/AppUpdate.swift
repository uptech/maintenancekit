//
//  AppUpdate.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

/// Returns all of the required info for an app update
public struct AppUpdate {
    /// Determines if an update is avaialble
    public let updateAvailable: Bool
    
    /// Returns true or false if the app is older than the minimum version
    public let isOlderThanMinimumVersion: Bool
    
    /// Is the update required
    public let isRequired: Bool
    
    /// Platform upgrade details
    public let details: Platform
    
    internal init(updateAvailable: Bool, isOlderThanMinimumVersion: Bool, details: Platform) {
        self.updateAvailable = updateAvailable
        self.isOlderThanMinimumVersion = isOlderThanMinimumVersion
        self.isRequired = details.isRequired
        self.details = details
    }
}
