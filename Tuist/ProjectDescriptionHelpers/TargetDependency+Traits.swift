import ProjectDescription

extension TargetDependency {
    /// Creates TargetDependency with `TestSupport` suffix to defined target. Only for `.project` cases.
    public var contract: TargetDependency {
        switch self {
        case .project(let target, let path, let status, let condition):
            return .project(target: target.contract, path: path, status: status, condition: condition)
        case .external(let name, let condition):
            return .external(name: name.contract, condition: condition)
        default:
            fatalError("Can't apply test support on \(self). Test support extension can be applied only on \".project\" case.")
        }
    }
}
