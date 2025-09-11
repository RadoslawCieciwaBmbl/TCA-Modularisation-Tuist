// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Dependencies",
    // This only defines minimum deployment target for, but does not support platform destination
    // platforms: [.iOS(.v17)],
    dependencies: [
       .package(
           url: "https://github.com/pointfreeco/swift-composable-architecture.git",
           from: "1.22.0"
       ),
    ]
)
