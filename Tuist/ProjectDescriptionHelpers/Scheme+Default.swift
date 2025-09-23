import ProjectDescription
import Foundation

extension Scheme {
    public enum SchemeType {
        case runnable
        case testable
        case buildable
    }

    /// Returns `Scheme` with build, test, run, archive, profile and analyze actions.
    ///
    /// NOTE: run action also run's lldbinit file from: `scripts/lldb/lldbinit`.
    public static func commonRunnableScheme(
        name: String,
        testTarget: String
    ) -> Scheme {
        Self.commonRunnableScheme(name: name, testTargets: [testTarget])
    }

    /// Returns `Scheme` with build, tests, run, archive, profile and analyze actions.
    ///
    /// NOTE: run action also run's lldbinit file from: `scripts/lldb/lldbinit`.
    public static func commonRunnableScheme(
        name: String,
        testTargets: [String] = []
    ) -> Scheme {
        return .scheme(
            name: name,
            buildAction: .buildAction(targets: [
                .target(name),
            ]),
            testAction: .targets(testTargets.map {
                .testableTarget(target: .target($0))
            }),
            runAction: .runAction(
                // TODO: Decide if it's still needed?
                // customLLDBInitFile: .relativeToRoot("scripts/lldb/lldbinit"),
                arguments: .iOS18_5_RuntimeIssueFix
            ),
            archiveAction: .archiveAction(configuration: "Release"),
            profileAction: .profileAction(),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    }

    /// Returns `Scheme` with build, tests, profile and analyze actions.
    public static func commonTestableScheme(
        name: String,
        testTarget: String,
        disableAllDiagnosticOptions: Bool = false
    ) -> Scheme {
        let testAction: TestAction = .targets(
            [
                .testableTarget(target: .target(testTarget)),
            ],
            arguments: .iOS18_5_RuntimeIssueFix,
            diagnosticsOptions: disableAllDiagnosticOptions ? .disabledAllOptions() : .options()
        )

        return .scheme(
            name: name,
            buildAction: .buildAction(targets: [
                .target(name),
            ]),
            testAction: testAction,
            profileAction: .profileAction(),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    }

    /// Returns `Scheme` with build, profile and analyze actions.
    ///
    /// Used for UI and Styles.
    public static func commonBuildableScheme(
        name: String
    ) -> Scheme {
        return .scheme(
            name: name,
            buildAction: .buildAction(targets: [
                .target(name),
            ]),
            profileAction: .profileAction(),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    }
}

extension [Scheme] {
    public static func scheme(from type: Scheme.SchemeType, for name: String) -> [Scheme] {
        switch type {
        case .testable:
            return [
                .commonTestableScheme(
                    name: name,
                    testTarget: name.tests
                ),
            ]
        case .runnable:
            return [
                .commonRunnableScheme(
                    name: name,
                    testTarget: name.tests
                ),
            ]
        case .buildable:
            return [
                .commonBuildableScheme(name: name),
            ]
        }
    }
}

extension SchemeDiagnosticsOptions {
    static func disabledAllOptions() -> ProjectDescription.SchemeDiagnosticsOptions {
        return self.options(
            addressSanitizerEnabled: false,
            detectStackUseAfterReturnEnabled: false,
            threadSanitizerEnabled: false,
            mainThreadCheckerEnabled: false,
            performanceAntipatternCheckerEnabled: false
        )
    }
}

extension ProjectDescription.Arguments {
    /// Issue is described in this error report: https://bugs.webkit.org/show_bug.cgi?id=293831
    /// and present in Xcode 16.4 and early Xcode 26 betas.
    static var iOS18_5_RuntimeIssueFix: Self? {
        guard FileManager.default.fileExists(atPath: "/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime") else {
            return nil
        }
        return .arguments(environmentVariables: [
            "DYLD_FALLBACK_LIBRARY_PATH": "/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot/System/Cryptexes/OS/usr/lib/swift",
        ])
    }
}
