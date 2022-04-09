//
//  GenericTabBarItemView.swift
//  
//
//  Created by Stef Kors on 09/04/2022.
//

import SwiftUI
import AppPreferences
import Design
import Foundation

struct GenericTabBarItemView: View {
    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    private var prefs: AppPreferencesModel = .shared

    @State
    var isHovering: Bool = false

    @State
    var isHoveringClose: Bool = false

    @State
    var isPressingClose: Bool = false

    var item: GenericTabItem

    func closeAction () {
        withAnimation {
            tabsModel.closeFileTab(item: item)
        }
    }

    @ObservedObject
    var tabsModel: GenericTabsModel

    var tabBarHeight: Double = 28.0

    var isActive: Bool {
        item.id == tabsModel.selectionState.selectedId
    }

    @ViewBuilder
    var content: some View {
        HStack(spacing: 0.0) {
            GenericTabDivider()
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    if isActive {
                        // Create a hidden button, if the tab is selected
                        // and hide the button in the ZStack.
                        Button(action: closeAction) {
                            Text("").hidden()
                        }
                        .frame(width: 0, height: 0)
                        .padding(0)
                        .opacity(0)
                        .keyboardShortcut("w", modifiers: [.command])
                    }
                    Button(action: closeAction) {
                        Image(systemName: "xmark")
                            .font(.system(size: 9.5, weight: .medium, design: .rounded))
                            .frame(width: 16, height: 16)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(isPressingClose ? .primary : .secondary)
                    .background(colorScheme == .dark
                                ? Color(nsColor: .white).opacity(isPressingClose ? 0.32 : isHoveringClose ? 0.18 : 0)
                                : Color(nsColor: .black).opacity(isPressingClose ? 0.29 : isHoveringClose ? 0.11 : 0)
                    )
                    .cornerRadius(2)
                    .accessibilityLabel(Text("Close"))
                    .onHover { hover in
                        isHoveringClose = hover
                    }
                    .pressAction {
                        isPressingClose = true
                    } onRelease: {
                        isPressingClose = false
                    }
                    .opacity(isHovering ? 1 : 0)
                    .animation(.easeInOut(duration: 0.15), value: isHovering)
                }
                Image(systemName: item.systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(
                        prefs.preferences.general.fileIconStyle == .color ? item.iconColor : .secondary
                    )
                    .frame(width: 12, height: 12)
                Text(item.url.lastPathComponent)
                    .font(.system(size: 11.0))
                    .lineLimit(1)
            }
            .frame(height: 28)
            .padding(.leading, 4)
            .padding(.trailing, 28)
            .background(
                Color(nsColor: isActive ? .clear : .black)
                    .opacity(
                        colorScheme == .dark
                        ? isHovering ? 0.15 : 0.45
                        : isHovering ? 0.15 : 0.05
                    )
                    .animation(.easeInOut(duration: 0.15), value: isHovering)
            )
            GenericTabDivider()
        }
        .frame(height: tabBarHeight)
        .foregroundColor(isActive ? .primary : .secondary)
        .onHover { hover in
            isHovering = hover
            DispatchQueue.main.async {
                if hover {
                    NSCursor.arrow.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
    var body: some View {
        Button(
            action: {
                tabsModel.selectionState.selectedId = item.id
            },
            label: { content }
        )
        .background(BlurView(
            material: NSVisualEffectView.Material.titlebar,
            blendingMode: NSVisualEffectView.BlendingMode.withinWindow
        ))
        .buttonStyle(.plain)
        .id(item.id)
        .keyboardShortcut(
            tabsModel.getTabKeyEquivalent(item: item),
            modifiers: [.command]
        )
        .contextMenu {
            Button("Close Tab") {
                withAnimation {
                    tabsModel.closeFileTab(item: item)
                }
            }
            Button("Close Other Tabs") {
                withAnimation {
                    tabsModel.closeFileTab(where: { $0.id != item.id })
                }
            }
            Button("Close Tabs to the Right") {
                withAnimation {
                    tabsModel.closeFileTabs(after: item)
                }
            }
        }
    }
}

fileprivate extension GenericTabsModel {
    func getTabKeyEquivalent(item: GenericTabItem) -> KeyEquivalent {
        for counter in 0..<9 where self.selectionState.tabs.count > counter &&
        self.selectionState.tabs[counter].fileName == item.fileName {
            return KeyEquivalent.init(
                Character.init("\(counter + 1)")
            )
        }

        return "0"
    }
}
