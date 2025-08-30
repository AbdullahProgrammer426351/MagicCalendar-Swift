//
//  public.swift
//  Practice Project
//
//  Created by APPLE on 29/08/2025.
//


import SwiftUI

/// Calendar icon equivalent to Kotlin sealed class
public enum CalendarIcon {
    /// SF Symbol name (vector-like)
    case system(name: String)
    /// Asset catalog image name (resource)
    case asset(name: String)
    /// Direct Image instance (you can pass Image("...") or Image(systemName: "..."))
    case image(Image)
    /// Custom SwiftUI content — store a closure that returns AnyView
    case customView(() -> AnyView)
}

// Convenience factory to let callers use @ViewBuilder easily:
public extension CalendarIcon {
    /// Use like: .custom { Text("Hi"); Image(systemName: "star") }
    static func custom<Content: View>(@ViewBuilder _ make: @escaping () -> Content) -> CalendarIcon {
        return .customView({ AnyView(make()) })
    }
}
