import ProjectDescription

extension Project {
    /// Enumeration used to simplify common conventions used in the repo. It's aiming to simplify naming conventions.
    ///
    /// It's aimed to be used by `commonModule` function and all conveniences methods.
    public enum ModuleTargetType {
        /// Represents common module, it creates a target of the same name as module.
        case main(dependencies: [TargetDependency] = [])
        /// Represents contract target, interface for the main `module`.
        case contract(dependencies: [TargetDependency] = [])
        /// Represents test target, supplementary to main `module`.
        case tests(dependencies: [TargetDependency])
        /// Represents resources bundle target, supplementary to main `module`.
        case resources
        /// Helper enum case, that can represents any type of target.
        case custom(_ target: Target)
    }

    /// Returns Project, that's defined with `ModuleTargetType` enumeration. It embeeds  common naming and structure conventions used in the code base.
    ///
    /// Other convenience methods are suggested to be used.
    ///
    /// - Parameters:
    ///   - name: Name of the module
    ///   - targets: `ModuleTargetType` enumeration of targets
    ///   - files: Additional no-compilable files for references in project (eg. documentation)
    public static func module(
        name: String,
        settings: Settings? = nil,
        packages: [ProjectDescription.Package] = [],
        targets: [ModuleTargetType],
        schemes: [Scheme]? = nil,
        files: [FileElement] = []
    ) -> Project {
        let tuistTargets: [Target] = targets.map { type in
            switch type {
            case .main(let dependencies):
                return .target(
                    for: name,
                    dependencies: dependencies
                )
            case .tests(let dependencies):
                return .unitTestsTarget(
                    name: name.tests,
                    dependencies: dependencies
                )
            case .resources:
                return .resourceBundle(
                    for: name
                )
            case .contract(let dependencies):
                return .target(
                    for: name.contract,
                    buildable: .contract,
                    dependencies: dependencies
                )
            case .custom(let target):
                return target
            }
        }

        let schemeType: Scheme.SchemeType = targets.contains { type in
            if case .tests(_) = type {
                return true
            } else {
                return false
            }
        } ? .testable : .buildable

        return Project(
            name: name,
            organizationName: GlobalSettings.organizationName,
            packages: packages,
            settings: settings,
            targets: tuistTargets.withDeploymentTargets(destinations: .iOS),
            schemes: schemes ?? .scheme(
                from: schemeType,
                for: name
            ),
            fileHeaderTemplate: .file(.relativeToRoot("Tuist/FileHeaderTemplate")),
            additionalFiles: files,
            resourceSynthesizers: []
        )
    }
}
