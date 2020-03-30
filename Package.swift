// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MaintenanceKit",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v11)
    ],
    products: [
        .library(name: "MaintenanceKit", targets: ["MaintenanceKit"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "MaintenanceKit", dependencies: []),
        .testTarget(name: "MaintenanceKitTests", dependencies: ["MaintenanceKit"]),
    ]
)
