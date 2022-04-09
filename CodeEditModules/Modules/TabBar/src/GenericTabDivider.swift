//
//  GenericTabDivider.swift
//  
//
//  Created by Stef Kors on 09/04/2022.
//

import SwiftUI

struct GenericTabDivider: View {
    @Environment(\.colorScheme)
    var colorScheme
    let width: CGFloat = 1

    var body: some View {
        Group {
            Rectangle()
        }
        .frame(width: width)
        .foregroundColor(
            Color(nsColor: colorScheme == .dark ? .white : .black)
                .opacity(colorScheme == .dark ? 0.08 : 0.12)
        )
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GenericTabDivider()
    }
}
