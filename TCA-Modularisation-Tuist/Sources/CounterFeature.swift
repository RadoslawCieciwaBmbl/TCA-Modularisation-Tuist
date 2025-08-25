//
//  FirstReducer.swift
//  TCA-Modularisation-Tuist
//
//  Created by Radek Cieciwa on 21/08/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case timerTurnToggled
        case timerTicked
    }

    enum CancelID {
        case timer
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    do {
                        let (data, _) = try await URLSession.shared
                            .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                        let fact = String(decoding: data, as: UTF8.self)
                        await send(.factResponse(fact))
                    } catch {
                        print(error)
                    }
                }
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .timerTicked:
                state.count += 1
                state.fact = nil
                return .none
                
            case .timerTurnToggled:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTicked)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}
