//
//  ArrayPreview.swift
//  TCA-Modularisation-Tuist
//
//  Created by Radek Cieciwa on 26/08/2025.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var array: [String] = []
    
    init(array: [String]) {
        self.array = array
    }
    
    func randomise() {
        array = Array(0..<array.count).map { _ in UUID().uuidString }
    }
}

struct ArrayView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, item in
                Text(item + "\(index)")
                    .onTapGesture {
                        viewModel.randomise()
                    }
            }
        }
    }
}

#Preview {
    ArrayView(viewModel: ViewModel(array: [
        "one",
        "two",
        "two",
        "two",
        "three"
    ]))
}
