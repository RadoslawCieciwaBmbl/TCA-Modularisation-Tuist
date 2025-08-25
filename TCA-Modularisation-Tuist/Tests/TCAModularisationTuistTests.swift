
@testable import TCA_Modularisation_Tuist
import ComposableArchitecture
import Testing

@MainActor
struct CounterFeatureTests {
    @Test
    func basicIncrementOperations() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) { state in
            state.count = 1
        }
        await store.send(.incrementButtonTapped) { state in
            state.count = 2
        }
        await store.send(.decrementButtonTapped) { state in
            state.count = 1
        }
    }
    
    @Test
    func testTimerSideEffect() async {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.timerTurnToggled){
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) {
            $0.count = 1
        }
        await store.send(.timerTurnToggled){
            $0.isTimerRunning = false
        }
    }

    @Test
    func testNetworkSideEffect() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { _ in return "Fixture" }
        }

        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(\.factResponse, timeout: .seconds(0.1)) {
          $0.isLoading = false
          $0.fact = "Fixture"
        }
    }
}
