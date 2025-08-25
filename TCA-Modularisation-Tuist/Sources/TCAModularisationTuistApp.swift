import SwiftUI
import ComposableArchitecture

@main
struct TCAModularisationTuistApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            CounterView(store: TCAModularisationTuistApp.store)
        }
    }
}
