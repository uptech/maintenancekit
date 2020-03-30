//
//  MaintenanceService.swift
//  
//
//  Created by Anthony Castelli on 3/30/20.
//

import Foundation

public struct MaintenanceService {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    public init() { }
    
    /// Fetch the JSON Data
    private func fetchMaintenanceInfo(for request: URLRequest, completion: @escaping (Result<Mode, Error>) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let urlResponse = response else {
                completion(.failure(MaintenanceError.missingResponse))
                return
            }
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(MaintenanceError.couldNotDecodeURLResponse))
                return
            }
            if httpUrlResponse.statusCode == 200 || httpUrlResponse.statusCode == 201 {
                guard let data = data else {
                    completion(.failure(MaintenanceError.couldNotDecodeData))
                    return
                }
                do {
                    let decoded = try self.decoder.decode(Mode.self, from: data)
                    completion(.success(decoded))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            } else {
                if let data = data, let body = String(data: data, encoding: String.Encoding.utf8) {
                    completion(.failure(MaintenanceError.other(body)))
                    return
                }
                completion(.failure(MaintenanceError.failure))
            }
        }
        task.resume()
    }
    
    /// Fetches the full maintenance info
    public func checkMaintenance(for app: MaintenanceServiceProtocol, completion: @escaping (Result<Mode, Error>) -> Void) {
        var request = URLRequest(url: app.maintenanceURL)
        request.httpMethod = "GET"
        self.fetchMaintenanceInfo(for: request) { result in
            switch result {
            case .success(let value): completion(.success(value))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    /// Fetches the maintenance info
    public func fetchMaintenance(for app: MaintenanceServiceProtocol, completion: @escaping (Result<Maintenance, Error>) -> Void) {
        var request = URLRequest(url: app.maintenanceURL)
        request.httpMethod = "GET"
        self.fetchMaintenanceInfo(for: request) { result in
            switch result {
            case .success(let value):
                guard let maintenance = value.maintenance else {
                    completion(.failure(MaintenanceError.missingMaintenance))
                    return
                }
                completion(.success(maintenance))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Checks if a new version if present for the app
    public func checkForNewVersion(from app: MaintenanceProtocol, completion: @escaping (Result<AppUpdate, Error>) -> Void) {
        var request = URLRequest(url: app.maintenanceURL)
        request.httpMethod = "GET"
        self.fetchMaintenanceInfo(for: request) { result in
            switch result {
            case .success(let value):
                guard let platform = value.upgrade?.platforms.first(where: { $0.type == app.platform }) else {
                    completion(.failure(MaintenanceError.missingPlatform))
                    return
                }
                switch app.checkMethod {
                case .shortVersion:
                    let currentVersion = Version(from: app.currentVersion)
                    /// **Version String Check**
                    /// Check if we have an update available. We use the current version against the latest version.
                    /// We also check if the minimum version is newer than the current version. If it is, we are using
                    /// a version that is super outdated and being sunset, meaning it's dead and no longer supported.
                    if platform.latestVersion > currentVersion {
                        // We need to update
                        completion(.success(.init(
                            updateAvailable: true,
                            isOlderThanMinimumVersion: platform.minimumVersion > currentVersion,
                            details: platform))
                        )
                        return
                    }
                    
                    // No Update needed
                    completion(.success(.init(updateAvailable: false, isOlderThanMinimumVersion: false, details: platform)))
                    
                case .build:
                    /// **Build Check**
                    /// Check if we have an update available. We use the current version against the latest version.
                    /// We also check if the minimum build is newer than the current build. If it is, we are using
                    /// a version that is super outdated and being sunset, meaning it's dead and no longer supported.
                    if platform.latestBuild > app.currentBuild {
                        // We need to update
                        completion(.success(.init(
                            updateAvailable: true,
                            isOlderThanMinimumVersion: platform.minimumBuild > app.currentBuild,
                            details: platform))
                        )
                        return
                    }
                    // No Update needed
                    completion(.success(.init(updateAvailable: false, isOlderThanMinimumVersion: false, details: platform)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
