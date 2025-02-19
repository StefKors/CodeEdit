//
//  BreadcrumbsView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 17.03.22.
//

import SwiftUI
import WorkspaceClient

public struct BreadcrumbsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var fileItems: [WorkspaceClient.FileItem] = []

    private let file: WorkspaceClient.FileItem
    private let tappedOpenFile: (WorkspaceClient.FileItem) -> Void

    public init(
        file: WorkspaceClient.FileItem,
        tappedOpenFile: @escaping (WorkspaceClient.FileItem) -> Void
    ) {
        self.file = file
        self.tappedOpenFile = tappedOpenFile
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(Color(nsColor: .controlBackgroundColor))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(fileItems, id: \.self) { fileItem in
                        if fileItem.parent != nil {
                            chevron
                        }
                        BreadcrumbsComponent(fileItem: fileItem, tappedOpenFile: tappedOpenFile)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .frame(height: 29)
        .overlay(alignment: .bottom) {
            Divider()
        }
        .onAppear {
            fileInfo(self.file)
        }
        .onChange(of: file) { newFile in
            fileInfo(newFile)
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.compact.right")
            .foregroundStyle(.secondary)
            .imageScale(.large)
    }

    private func fileInfo(_ file: WorkspaceClient.FileItem) {
        fileItems = []
        var currentFile: WorkspaceClient.FileItem? = file
        while let currentFileLoop = currentFile {
            fileItems.insert(currentFileLoop, at: 0)
            currentFile = currentFileLoop.parent
        }
    }
}

struct BreadcrumbsView_Previews: PreviewProvider {
    static var previews: some View {
        BreadcrumbsView(file: .init(url: .init(fileURLWithPath: ""))) { _ in }
            .previewLayout(.fixed(width: 500, height: 29))
            .preferredColorScheme(.dark)

        BreadcrumbsView(file: .init(url: .init(fileURLWithPath: ""))) { _ in }
            .previewLayout(.fixed(width: 500, height: 29))
            .preferredColorScheme(.light)
    }
}
