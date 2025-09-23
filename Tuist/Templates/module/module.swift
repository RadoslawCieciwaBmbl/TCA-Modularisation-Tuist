import ProjectDescription

private let nameAttribute: Template.Attribute = .required("name")

private let template = Template(
    description: "Template for creating a common module",
    attributes: [
        nameAttribute,
    ],
    items: [
        .file(
            path: "Project.swift",
            templatePath: "Project.swift.stencil"
        ),
        .file(
            path: "Sources/\(nameAttribute).swift",
            templatePath: "Sources/__name__.swift.stencil"
        ),
        .file(
            path: "Tests/\(nameAttribute)Tests.swift",
            templatePath: "Tests/__name__Tests.swift.stencil"
        ),
        .file(
            path: "Contract/\(nameAttribute)Contract.swift",
            templatePath: "Contract/__name__Contract.swift.stencil"
        ),
    ]
)
