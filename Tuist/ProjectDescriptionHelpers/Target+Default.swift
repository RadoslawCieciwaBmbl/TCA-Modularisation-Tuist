import ProjectDescription

extension Target {
    /// Returns target representing common module. Sensible Default.
    ///
    /// - Parameters:
    ///   - name: name of the module
    ///   - sources: represents path to sources, default value is `Sources`
    ///   - dependencies: list of dependencies, empty by default
    ///   - settings: default is `targetUniversal`
    public static func target(
        for name: String,
        buildable: [BuildableFolder]? = nil,
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: name.intoBundleId,
            buildableFolders: buildable ?? .main,
            dependencies: dependencies,
            settings: settings
        )
    }

    /// Returns target representing unit test. Target code is stored under "Tests" directory.
    ///
    /// - Parameters:
    ///   - name: unit test target name, by convention should be suffixed with `Tests`
    ///   - dependencies: list of unit test target dependencies
    public static func unitTestsTarget(
        name: String,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency],
        settings: Settings? = nil
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .unitTests,
            bundleId: name.intoBundleId,
            resources: resources,
            buildableFolders: .tests,
            dependencies: dependencies,
            settings: settings
        )
    }

    /// Returns resource bundle target. Pass component name, with no Resource suffix.
    ///
    /// Note that suffix is added inside, with pattern
    /// - name = `COMPONENT_Resources`
    /// - resources = `COMPONENT.Resources/Resources/**`
    /// - config files = `COMPONENT.Resources`
    /// - bundle ID = `COMPONENT-Resources`
    public static func resourceBundle(
        for componentName: String,
        settings: Settings? = nil
    ) -> Target {
        let componentResources = componentName.resources
        return .target(
            name: componentResources,
            destinations: .iOS,
            product: .bundle,
            bundleId: componentResources.intoBundleId,
            resources: [
                .glob(pattern: "\(componentName).Resources/Resources/**"),
            ],
            settings: settings
        )
    }
}
