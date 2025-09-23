import ProjectDescription

extension TargetDependency {
    /// Returns **Module** dependecy.
    /// Resolves into: `Modules/<Module>`.
    ///
    /// If specific target type is required, use following extensions
    /// - `.testSupport` extension for `TestSupport` target for the same named project
    /// or rollback to `ProjectDescription` API.
    public static func module(_ name: String) -> Self {
        .project(target: name, path: .relativeToRoot("Modules/\(name)"))
    }
}
