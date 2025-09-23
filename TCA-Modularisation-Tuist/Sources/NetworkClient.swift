//
//  NetworkClient.swift
//  TCA-Modularisation-Tuist
//
//  Created by Radek Cieciwa on 16/09/2025.
//

import Foundation
import Combine

struct NetworkClient {
    func getData() async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "Hello, World!"
    }

    private let subject = PassthroughSubject<Int, Never>()
    
    func getPublisher() -> AnyPublisher<Int, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    func simulate() {
        subject.send(Int.random(in: 0...1_000))
    }
}
