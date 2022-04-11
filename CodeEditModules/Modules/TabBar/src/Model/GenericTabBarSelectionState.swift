//
//  GenericTabBarSelectionState.swift
//  
//
//  Created by Stef Kors on 09/04/2022.
//

import Foundation
import SwiftUI

open class GenericTabBarSelectionState: Codable {
    public var selectedId: String?
    public var tabs: [GenericTabItem] = [] {
        didSet {
            selectDefaultTab()
        }
    }

    public var selected: GenericTabItem? {
        guard let selectedId = selectedId else { return nil }
        return tabs.first(where: { $0.id == selectedId })
    }

    enum CodingKeys: String, CodingKey {
        case selectedId, tabs
    }

    public init(tabs: [GenericTabItem] = []) {
        self.tabs = tabs
        selectDefaultTab()
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selectedId = try container.decode(String?.self, forKey: .selectedId)
        tabs = try container.decode([GenericTabItem].self, forKey: .tabs)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selectedId, forKey: .selectedId)
        try container.encode(tabs, forKey: .tabs)
    }

    /// Set the first tab as selected tab
    private func selectDefaultTab() {
        if selectedId == nil, let firstTab = tabs.first {
            selectedId = firstTab.id
        }
    }
}
