//
//  GenericTabsModel.swift
//  
//
//  Created by Stef Kors on 09/04/2022.
//

import Foundation

open class GenericTabsModel: ObservableObject {
    @Published var selectionState: GenericTabBarSelectionState
    public var tabs: [GenericTabItem] {
        selectionState.tabs
    }
    public init(tabs: [GenericTabItem]) {
        selectionState = .init(tabs: tabs)
    }

    open func createFileTab(item: GenericTabItem) {
        selectionState.tabs.append(item)
    }

    open func closeFileTab(item: GenericTabItem) {
        guard let idx = selectionState.tabs.firstIndex(of: item) else { return }
        let closedFileItem = selectionState.tabs.remove(at: idx)
        guard closedFileItem.id == item.id else { return }

        if selectionState.tabs.isEmpty {
            selectionState.selectedId = nil
        } else if idx == 0 {
            selectionState.selectedId = selectionState.tabs.first?.id
        } else {
            selectionState.selectedId = selectionState.tabs[idx - 1].id
        }
    }
    open func closeFileTabs<Items>(items: Items) where Items: Collection, Items.Element == GenericTabItem {
        // TODO: Could potentially be optimized
        for item in items {
            closeFileTab(item: item)
        }
    }

    open func closeFileTab(where predicate: (GenericTabItem) -> Bool) {
        closeFileTabs(items: selectionState.tabs.filter(predicate))
    }

    open func closeFileTabs(after item: GenericTabItem) {
        guard let startIdx = selectionState.tabs.firstIndex(where: { $0.id == item.id }) else {
            assert(false, "Expected file item to be present in tabs")
            return
        }

        let range = selectionState.tabs[(startIdx+1)...]
        closeFileTabs(items: range)
    }
}
