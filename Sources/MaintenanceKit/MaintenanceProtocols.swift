//
//  MaintenanceProtocols.swift
//
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

/// Version Check Type
public enum VersionCheckMethod {
    /// The Short Version (CFBundleShortVersionString) of the app
    case shortVersion
    
    /// The Build Number (CFBundleVersion) of the app
    case build
}

/// Upgrade Check Protocol
public protocol UpgradeProtocol {
    /// The Current Version (String) of the app. CFBundleShortVersionString
    var currentVersion: String { get }
    
    /// The Current Version (Build) of the app. CFBundleVersion
    var currentBuild: Int { get }
    
    /// The platform to check for updates on
    var platform: PlatformType { get }
    
    /// The method to check the version by. Either with the version string
    /// or the build number. iOS can use either, but it's best to use the
    /// the build for macOS.
    var checkMethod: VersionCheckMethod { get }
}

/// Maintenance Service Protocol
/// This is a required protocol for the maintenance service to function.
public protocol MaintenanceServiceProtocol {
    /// The URL of the payload file
    var maintenanceURL: URL { get }
}

/// Conformance to both MaintenanceNetworkProtocol & UpgradeProtocol
public typealias MaintenanceProtocol = MaintenanceServiceProtocol & UpgradeProtocol
