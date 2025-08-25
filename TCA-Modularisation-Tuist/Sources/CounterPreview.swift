//
//  CounterFeature.swift
//  TCA-Modularisation-Tuist
//
//  Created by Radek Cieciwa on 25/08/2025.
//

import SwiftUI
import ComposableArchitecture

#Preview {
  CounterView(
    store: Store(initialState: CounterFeature.State()) {
      CounterFeature()
    }
  )
}
