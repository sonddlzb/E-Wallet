//
//  FilterSelectionViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import Foundation

struct FilterSelectionViewModel {
    var listSelections: [String]
    var selectedSelection: String?

    static func makeEmpty() -> FilterSelectionViewModel {
        return FilterSelectionViewModel(listSelections: [])
    }

    func item(at index: Int) -> FilterSelectionItemViewModel {
        return FilterSelectionItemViewModel(selection: self.listSelections[index])
    }

    func numberOfSelections() -> Int {
        return self.listSelections.count
    }

    func selection(at index: Int) -> String {
        return self.listSelections[index]
    }
}
