import Foundation

public extension String {

    // MARK: Conventions

    /// NOTE: This extensions are used to clarify naming conventions we use as sensible defaults.

    /// Appends `Tests`, eg. by extending `BFFeature`, the outcome is: `BFFeatureTests`.
    var tests: String {
        "\(self)Tests"
    }
    /// Appends `_Resources`, eg. by extending `BFFeature`, the outcome is: `BFFeature_Resources`.
    ///
    /// NOTE: We use underscore (`_`) as dot (`.`) is not allowed.
    var resources: String {
        "\(self)_Resources"
    }

    /// Appends `_Resources`, eg. by extending `BFFeature`, the outcome is: `BFFeature_Resources`.
    ///
    /// NOTE: We use underscore (`_`) as dot (`.`) is not allowed.
    var contract: String {
        "\(self)Contract"
    }

    // MARK: Conversions

    /// Returns bundle id composed from the name and common prefix.
    ///
    /// NOTE: Underscores (`_`) are not allowed in bundle ID's and are replaced with hyphens (`-`).
    /// More under this [link](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier).
    var intoBundleId: String {
        let sanitisedName = self.replacingOccurrences(of: "_", with: "-")
        return "\(GlobalSettings.organisationIdentifier).\(sanitisedName)"
    }
}
