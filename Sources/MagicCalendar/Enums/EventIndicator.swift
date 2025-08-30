//
//  CircleType.swift
//  Practice Project
//
//  Created by APPLE on 29/08/2025.
//


import SwiftUI

public enum CircleType {
    case filled
    case stroke
    case dotted
    case transparent
}

public enum RectangleType {
    case filled
    case stroke
    case dotted
    case transparent
}

public enum EventIndicator {
    case dot(color: Color)
    case badge(color: Color, count: Int)
    case bar(color: Color, thickness: CGFloat = 2, radius: CGFloat = 8)
    case ring(color: Color, thickness: CGFloat = 2)
    case circle(color: Color, strokeWidth: CGFloat = 2, type: CircleType = .filled)
    case rectangle(color: Color, cornerRadius: CGFloat = 4, strokeWidth: CGFloat = 2, type: RectangleType = .filled)
    case custom(content: () -> AnyView)
}
