import XCTest
@testable import MaintenanceKit

final class MaintenanceKitTests: XCTestCase {
    let messageString = """
    {
        "title": "Title",
        "body": "Body"
    }
    """
    
    let maintenanceString = """
    {
        "active": true,
        "offline": true,
        "scheduled": false,
        "start_date": "2020-03-27T11:49:01+0000",
        "end_date": "2020-03-27T11:49:01+0000",
        "message": null
    }
    """
    
    let platformString = """
    {
        "platform": "ios",
        "latest_version": "1.0.0",
        "latest_build_number": 21,
        "minimum_version": "1.0.0",
        "minimum_build_number": 21,
        "store_url": "http://upte.ch",
        "required_update": false,
        "show_version_info": false,
        "message": null
    }
    """
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func testMessageDecoding() throws {
        guard let data = self.messageString.data(using: .utf8) else {
            XCTAssertNil("Could not convert JSON to data")
            return
        }
        let model = try self.decoder.decode(Message.self, from: data)
        XCTAssertEqual(model.title, "Title")
        XCTAssertEqual(model.body, "Body")
    }
    
    func testMaintenanceDecoding() throws {
        guard let data = self.maintenanceString.data(using: .utf8) else {
            XCTAssertNil("Could not convert JSON to data")
            return
        }
        let model = try self.decoder.decode(Maintenance.self, from: data)
        XCTAssertEqual(model.isActive, true)
        XCTAssertEqual(model.isOffline, true)
        XCTAssertEqual(model.isScheduled, false)
        XCTAssertEqual(model.message, nil)
    }
    
    func testPlatformDecoding() throws {
        guard let data = self.platformString.data(using: .utf8) else {
            XCTAssertNil("Could not convert JSON to data")
            return
        }
        let model = try self.decoder.decode(Platform.self, from: data)
        XCTAssertEqual(model.type, .iOS)
        XCTAssertEqual(model.latestVersion, Version(major: 1, minor: 0, patch: 0))
        XCTAssertEqual(model.latestBuild, 21)
        XCTAssertEqual(model.minimumVersion, Version(major: 1, minor: 0, patch: 0))
        XCTAssertEqual(model.minimumBuild, 21)
        XCTAssertEqual(model.store, URL(string: "http://upte.ch"))
        XCTAssertEqual(model.isRequired, false)
        XCTAssertEqual(model.showVersionInfo, false)
        XCTAssertEqual(model.message, nil)
    }
    
    func testModeDecoding() throws {
        // Just for the sake of testing everything lets manually generate the data based off of the other strings
        // we already have. Also we want to test the message decoding in a specific spot so we're using
        // string replacements.
        let string = """
        {
        "upgrade": { "platforms": [\(self.platformString)] },
        "maintenance": \(self.maintenanceString.replacingOccurrences(of: "\"message\": null", with: "\"message\": \(self.messageString)"))
        }
        """
        guard let data = string.data(using: .utf8) else {
            XCTAssertNil("Could not convert JSON to data")
            return
        }
        let model = try self.decoder.decode(Mode.self, from: data)
        XCTAssertEqual(model.upgrade?.platforms.count, 1)
        XCTAssertEqual(model.maintenance?.isActive, true)
        XCTAssertEqual(model.maintenance?.message?.title, "Title")
        XCTAssertEqual(model.maintenance?.message?.body, "Body")
    }
    
    func testVersionChecking() {
        let version1 = Version(from: "2.3.4")
        let version2 = Version(from: "2.3.3")
        
        XCTAssertNotEqual(version1, version2)
        
        XCTAssertGreaterThan(version1, version2)
        XCTAssertGreaterThanOrEqual(version1, version2)
        
        XCTAssertLessThan(version2, version1)
        XCTAssertLessThanOrEqual(version2, version1)
    }

    static var allTests = [
        ("testMessageDecoding", testMessageDecoding),
        ("testMaintenanceDecoding", testMaintenanceDecoding),
        ("testPlatformDecoding", testPlatformDecoding),
        ("testModeDecoding", testModeDecoding),
        ("testVersionChecking", testVersionChecking)
    ]
}
