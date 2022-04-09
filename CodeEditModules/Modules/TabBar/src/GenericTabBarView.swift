//
//  GenericTabBarView.swift
//  
//
//  Created by Stef Kors on 09/04/2022.
//

import SwiftUI
import Design

/// # GenericTabBar
///
/// Tabs for everywhere
///
public struct GenericTabBarView<Content: View>: View {
    @Environment(\.colorScheme)
    var colorScheme

    @ObservedObject
    var model: GenericTabsModel

    var content: (GenericTabItem) -> Content

    /// Initialize with GitClient
    /// - Parameter gitClient: a GitClient
    public init(model: GenericTabsModel, @ViewBuilder content: @escaping (GenericTabItem) -> Content) {
        self.model = model
        self.content = content
    }

    public var body: some View {
        VStack {
            tabs
            if let selected = model.selectionState.selected ?? model.tabs.first {
                content(selected)
            }
        }
    }

    /// The actual status bar
    var tabBarHeight = 28.0

    private var tabs: some View {
        VStack(spacing: 0.0) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(
                        Color(nsColor: .black).opacity(colorScheme == .dark ? 0.45 : 0.05)
                    )
                    .frame(height: 28)
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { value in
                        HStack(alignment: .center, spacing: -1) {
                            ForEach(model.tabs, id: \.id) { tabItem in
                                GenericTabBarItemView(item: tabItem, tabsModel: model)
                            }
                        }
                        .onAppear {
                            value.scrollTo(self.model.selectionState.selectedId)
                        }
                    }
                }
                .padding(.leading, -1)
            }
        }
        .background(
            BlurView(
                material: NSVisualEffectView.Material.titlebar,
                blendingMode: NSVisualEffectView.BlendingMode.withinWindow
            )
        )
    }
}

// public protocol TabsModel: ObservableObject {
//     var tabs: [String] { get set }
// }

// struct SwiftUIView_Previews: PreviewProvider {
//     static var previews: some View {
//         GenericTabBarView(model: )
//     }
// }
