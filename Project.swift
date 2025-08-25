import ProjectDescription

let project = Project(
    name: "TCA-Modularisation-Tuist",
    targets: [
        .target(
            name: "TCA-Modularisation-Tuist",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.TCA-Modularisation-Tuist",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true,
                    ]
                ]
            ),
            sources: ["TCA-Modularisation-Tuist/Sources/**"],
            resources: ["TCA-Modularisation-Tuist/Resources/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
            ]
        ),
        .target(
            name: "TCA-Modularisation-TuistTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TCA-Modularisation-TuistTests",
            infoPlist: .default,
            sources: ["TCA-Modularisation-Tuist/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TCA-Modularisation-Tuist")]
        ),
    ]
)
