import ProjectDescription

public extension Settings {
    // Adopt specific trait setting when appropriate
    // /// Returns `TestSupport` settings.
    // static func testSupport(
    //     settings values: SettingsDictionaryValues = .empty
    // ) -> Settings {
    //     ...
    // }

    /// Convenience function to resolve xcconfig path and settings per configuration.
    ///
    /// Note: Links the same xcconfig for all configurations.
    /// - Parameters:
    ///   - values: Expected variant of values
    ///   - xcConfigFilePath: xcconfig file, full path from Root
    /// - Returns: `Settings` for defined values and xcconfig file path
    static func baseSettings(
        settings values: SettingsDictionaryValues
    ) -> Settings {
        .settings(
            configurations: [
                .debug(
                    name: "Debug",
                    settings: .developmentConfiguration.merging(values.debug) { $1 }
                ),
                .release(
                    name: "Release",
                    settings: .deploymentConfiguration.merging(values.release) { $1 }
                ),
            ]
        )
    }
}

public extension SettingsDictionary {
    static var swift6: SettingsDictionary {
        [
            "SWIFT_VERSION": "6.2",
        ]
    }

    static var developmentConfiguration: Self {
        [
            /// Previews require `Incremental` `SWIFT_COMPILATION_MODE` mode. Usually it should be
            /// automatically detected. From Xcode 16.4 `singlefile` mode of incremental mode is required.
            /// On TeamCity, it's overriden with the `wholemodule` (part of Fastlane call).
            "SWIFT_COMPILATION_MODE": "singlefile",
        ]
    }

    /// Represents core settings for deployment configurations: Calabash, Distribution and Release.
    static var deploymentConfiguration: Self {
        [
            /// Expected for better performance and optimisations
            "SWIFT_COMPILATION_MODE": "wholemodule",
        ]
    }

    /// Overrides `MACH_O_TYPE` field
    var asStaticLib: Self {
        merging([
            "MACH_O_TYPE": "staticlib",
        ]) { _, new in new }
    }

    /// Overrides `MACH_O_TYPE` field
    var asDynamicLib: Self {
        merging([
            "MACH_O_TYPE": "mh_dylib",
        ]) { _, new in new }
    }
}

extension ProjectDescription.SettingValue {
    /// Adds a flag to the value unless it is already present.
    ///
    /// - Parameter flag: A flag to add including the argument dash "-", for example "-ObjC".
    /// - Returns: A new value that includes the flag or itself unchanged.
    func addFlagIfMissing(_ flag: String) -> Self {
        switch self {
            case .array(let array):
                guard array.contains(flag) else {
                    return .array(array + [flag])
                }
                return self

            case .string(let string):
                guard string.split(whereSeparator: { $0.isWhitespace }).map({ String($0) }).contains(flag) else {
                    return .string(string + " " + flag)
                }
                return self

            @unknown default:
                fatalError("Unsupported setting value type: \(String(describing: self))")
        }
    }
}

/// Defines settings values for configurations.
public enum SettingsDictionaryValues {
    /// None additional configurations are set
    case empty
    /// Sets **the same** settings for all configurations: Debug and Release.
    case all(SettingsDictionary)
    /// Defines separate values for each configuration: Debug and Release.
    case unique(
        debug: SettingsDictionary,
        release: SettingsDictionary
    )

    /// Extracts debug values from any case.
    var debug: SettingsDictionary {
        switch self {
        case .unique(debug: let debug, release: _):
            return debug
        case .all(let shared):
            return shared
        case .empty:
            return [:]
        }
    }

    /// Extracts release values from any case
    var release: SettingsDictionary {
        switch self {
        case .unique(debug: _, release: let release):
            return release
        case .all(let shared):
            return shared
        case .empty:
            return [:]
        }
    }
}
