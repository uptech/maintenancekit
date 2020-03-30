//
//  MaintenanceError.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

public enum MaintenanceError: Error, LocalizedError {
    case missingResponse
    case couldNotDecodeURLResponse
    case couldNotDecodeData
    case failure
    case other(String)
    
    case missingMaintenance
    case missingPlatform
    
    public var localizedDescription: String {
        switch self {
        case .missingResponse: return "Missing Response Object"
        case .couldNotDecodeURLResponse: return "Could not decode URL Response. Please try again."
        case .couldNotDecodeData: return "Could not decode data. Verify your JSON payload is valid and try again."
        case .failure: return "Something went wrong trying to fetch the maintenance file. Please veryify it's uploaded correctly and try again."
        case .other(let message): return message
            
        case .missingMaintenance: return "Missing Maintenance info. This error can be ignored if you are not using the maintenance functionality."
        case .missingPlatform: return "Missing iOS Platform. This error can be ignored if you are ommitting platforms when there isn't an upgrade."
        }
    }
}
