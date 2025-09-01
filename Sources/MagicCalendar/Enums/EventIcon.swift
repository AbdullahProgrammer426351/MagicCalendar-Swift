//
//  IconPosition.swift
//  Practice Project
//
//  Created by APPLE on 29/08/2025.
//


import SwiftUI

public enum EventIcon {
    case resource(name: String, position: Alignment = .topTrailing, padding:CGFloat = 1)
    case system(name: String, position: Alignment = .topTrailing, padding:CGFloat = 1)
    case custom(content: () -> AnyView, position: Alignment = .topTrailing, padding:CGFloat = 1)
}
