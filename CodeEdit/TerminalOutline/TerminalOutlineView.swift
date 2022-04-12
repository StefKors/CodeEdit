//
//  TerminalOutlineView.swift
//  CodeEdit
//
//  Created by Stef Kors on 12/04/2022.
//

import SwiftUI
import WorkspaceClient
import AppPreferences

/// Wraps an ``TerminalOutlineViewController`` inside a `NSViewControllerRepresentable`
struct TerminalOutlineView: NSViewControllerRepresentable {

    @StateObject
    var workspace: WorkspaceDocument

    @StateObject
    var prefs: AppPreferencesModel = .shared

    typealias NSViewControllerType = TerminalOutlineViewController

    func makeNSViewController(context: Context) -> TerminalOutlineViewController {
        let controller = TerminalOutlineViewController()
        controller.workspace = workspace
        controller.iconColor = prefs.preferences.general.terminalIconStyle

        return controller
    }

    func updateNSViewController(_ nsViewController: TerminalOutlineViewController, context: Context) {
        nsViewController.iconColor = prefs.preferences.general.terminalIconStyle
        nsViewController.updateSelection()
        nsViewController.rowHeight = rowHeight
        return
    }

    /// Returns the row height depending on the `projectNavigatorSize` in `AppPreferences`.
    ///
    /// * `small`: 20
    /// * `medium`: 22
    /// * `large`: 24
    private var rowHeight: Double {
        switch prefs.preferences.general.projectNavigatorSize {
        case .small: return 20
        case .medium: return 22
        case .large: return 24
        }
    }
}
