import ProjectDescription

extension Project {
    /// Returns project that represents Application module
    public static func app(
        name: String,
        settings: Settings? = nil,
        targets: [Target] = [],
        schemes: [Scheme] = []
    ) -> Project {
        Project(
            name: name,
            organizationName: GlobalSettings.organizationName,
            settings: settings ?? .baseSettings(
                settings: .all(.swift6)
            ),
            targets: targets.withDeploymentTargets(),
            schemes: schemes,
            fileHeaderTemplate: .file(.relativeToRoot("Tuist/FileHeaderTemplate")),
            resourceSynthesizers: []
        )
    }
}

extension [Target] {
    func withDeploymentTargets(destinations: Destinations = [.iPhone]) -> Self {
        map { oldTarget in
            var newTarget = oldTarget
            newTarget.destinations = newTarget.destinations.union(destinations)
            newTarget.deploymentTargets = .iOS("\(GlobalSettings.iOSMinimumDeploymentTarget)")
            return newTarget
        }
    }
}
