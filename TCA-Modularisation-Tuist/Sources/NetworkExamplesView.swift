//
//  NetworkExamplesView.swift
//  TCA-Modularisation-Tuist
//
//  Created by Radek Cieciwa on 16/09/2025.
//

import Foundation
import SwiftUI
import Combine

// struct NetworkExamplesView: View {
//    @State var networkValue: String = ""
//    @State private var observers: Set<AnyCancellable> = .init()
//    private let networkClient = NetworkClient()
//
//    var body: some View {
//        Text(self.networkValue)
//        Button("Work with observers") {
//            self.getValue()
//        }
//        .onAppear {
//            self.networkClient
//                .getPublisher()
//                .sink(receiveValue: { value in
//                    self.networkValue = "\(value)"
//                }).store(in: &self.observers)
//        }
//    }
//
//    func getValue() {
//        self.networkClient.simulate()
//    }
// }

struct NetworkExamplesView: View {
    @State var networkValue: String = ""
    private let networkClient = NetworkClient()

    var body: some View {
        Text(self.networkValue)
            .onReceive(
                self
                    .networkClient
                    .getPublisher()) { value in
                        self.networkValue = "Working directly on Publisher \(value)"
                    }
        Button("Hit me") {
            self.getValue()
        }
        .withRadarBlip
    }

    func getValue() {
        self.networkClient.simulate()
    }
}

#Preview {
    NetworkExamplesView()
}

struct RadarBlip: ViewModifier {
    let animate: Bool

    func body(content: Content) -> some View {
        content
            .animation(.bouncy, body: {
                $0.scaleEffect(animate ? 1.4 : 1.0)
            })
    }
}

extension View {
    var withRadarBlip: some View {
        self.modifier(
            RadarBlip(animate: true)
        )
    }
}
