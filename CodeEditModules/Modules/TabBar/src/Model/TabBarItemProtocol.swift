//
//  File.swift
//  
//
//  Created by Stef Kors on 09/04/2022.
//

import SwiftUI
import Foundation

public protocol TabBarItem: Identifiable, Codable where ID == String {

    var id: ID { get set }

    var url: URL { get set }

    var iconColor: Color { get }

    var systemImage: String { get }

    var fileName: String { get }

}
