//
//  WorkspaceView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 3/10/22.
//

import SwiftUI
import WorkspaceClient
import StatusBar
import TerminalEmulator

struct WorkspaceView: View {
    init(windowController: NSWindowController, workspace: WorkspaceDocument) {
        self.windowController = windowController
        self.workspace = workspace
    }

    var windowController: NSWindowController
    var tabBarHeight = 28.0
    private var path: String = ""

    @ObservedObject
    var workspace: WorkspaceDocument

    @State
    private var showingAlert = false

    @State
    private var alertTitle = ""

    @State
    private var alertMsg = ""

    @State
    var showInspector = true

    var body: some View {
        ZStack {
            if workspace.workspaceClient != nil {
                WorkspaceCodeFileView(windowController: windowController, workspace: workspace)
                    .safeAreaInset(edge: .bottom) {
                        if let url = workspace.fileURL {
                            StatusBarView(workspaceURL: url) { _ in
                                HSplitView {
                                    TerminalOutlineView(workspace: workspace)
                                    TerminalEmulatorView(url: URL(string: "~/Developer")!)
                                    TerminalEmulatorView(url: URL(string: "~/Developer/beam")!)
                                }
                                .frame(minHeight: 0,
                                       idealHeight: 300,
                                       maxHeight: 300)
                                        // .frame(minHeight: 0,
                                        //        idealHeight: model.isExpanded ? model.currentHeight : 0,
                                        //        maxHeight: model.isExpanded ? model.currentHeight : 0)
                            }
                        }
                    }
            } else {
                EmptyView()
            }
        }
        .alert(alertTitle, isPresented: $showingAlert, actions: {
            Button(
                action: { showingAlert = false },
                label: { Text("OK") }
            )
        }, message: { Text(alertMsg) })
        .onChange(of: workspace.selectionState.selectedId) { newValue in
            if newValue == nil {
                windowController.window?.subtitle = ""
            }
        }
    }
}

struct WorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceView(windowController: NSWindowController(), workspace: .init())
    }
}
