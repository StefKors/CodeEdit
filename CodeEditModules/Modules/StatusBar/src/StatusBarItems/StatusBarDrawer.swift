//
//  StatusBarDrawer.swift
//  
//
//  Created by Lukas Pistrol on 22.03.22.
//

import SwiftUI
import TerminalEmulator
import GenericTabBar

internal struct StatusBarDrawer: View {
    @ObservedObject
    private var model: StatusBarModel

    internal init(model: StatusBarModel) {
        self.model = model
    }

    internal var body: some View {
        GenericTabBarView(model: model) { item in
            Text(item.url.absoluteString)
            // It's switching but there is something odd with the TerminalEmulatorView
            TerminalEmulatorView(url: item.url)
                .frame(minHeight: 0,
                       idealHeight: model.isExpanded ? model.currentHeight : 0,
                       maxHeight: model.isExpanded ? model.currentHeight : 0)
        }
    }
}
