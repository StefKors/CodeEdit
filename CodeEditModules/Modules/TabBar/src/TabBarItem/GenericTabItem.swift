//
//  GenericTabItem.swift
//  
//
//  Created by Stef Kors on 09/04/2022.
//

import Foundation
import SwiftUI

enum GenericTabItemCodingKeys: String, CodingKey {
    case id
    case url
}

public struct GenericTabItem: TabBarItem, Codable, Hashable {
    public var id: String
    public var url: URL
    public var iconColor: Color = .accentColor
    public var systemImage: String = "terminal"
    public var fileName: String {
        url.lastPathComponent
    }
    public var fileType: String {
        url.lastPathComponent.components(separatedBy: ".").last ?? ""
    }

    public init(url: URL) {
        self.id = UUID().uuidString
        self.url = url
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GenericTabItemCodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        url = try values.decode(URL.self, forKey: .url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GenericTabItemCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
    }
}
