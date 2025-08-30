//
//  CircleTypeModifier.swift
//  Practice Project
//
//  Created by APPLE on 30/08/2025.
//

import SwiftUI


struct CircleTypeModifier: ViewModifier {
    let type: CircleType
    let color: Color
    let strokeWidth: CGFloat

    func body(content: Content) -> some View {
        switch type {
        case .filled:
            content
                .overlay(Circle().fill(color))
        case .stroke:
            content
                .overlay(Circle().stroke(color, lineWidth: strokeWidth))
        case .dotted:
            content
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: strokeWidth, dash: [6])))
        case .transparent:
            content
                .overlay(Circle().fill(color.opacity(0.3)))
        }
    }
}

struct RectangleTypeModifier: ViewModifier {
    let type: RectangleType
    let color: Color
    let cornerRadius: CGFloat
    let strokeWidth: CGFloat

    func body(content: Content) -> some View {
        switch type {
        case .filled:
            content
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).fill(color))
        case .stroke:
            content
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: strokeWidth))
        case .dotted:
            content
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(style: StrokeStyle(lineWidth: strokeWidth, dash: [6])))
        case .transparent:
            content
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).fill(color.opacity(0.3)))
        }
    }
}
