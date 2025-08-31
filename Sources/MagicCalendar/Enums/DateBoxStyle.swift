//
//  DateBoxStyle.swift
//  Practice Project
//
//  Created by APPLE on 29/08/2025.
//


import SwiftUI

/// Calendar date box styles (equivalent to Kotlin sealed class)
public enum DateBoxStyle {
    case clear
    case filledCircle(color: Color)
    case filledRectangle(color: Color, cornerRadius: CGFloat = 2)
    case borderedCircle(borderColor: Color, borderWidth: CGFloat = 2)
    case borderedRectangle(borderColor: Color, borderWidth: CGFloat = 2, cornerRadius: CGFloat = 2)
    case dottedCircle(dotColor: Color, dotSize: CGFloat = 4)
    case dottedRectangle(dotColor: Color, dotSize: CGFloat = 4, cornerRadius: CGFloat = 2)
    case customDateBoxStyle(content: AnyView)
}

public extension DateBoxStyle {
    static func custom<Content: View>(@ViewBuilder _ make: () -> Content) -> DateBoxStyle {
        .customDateBoxStyle(content: AnyView(make()))
    }
}
