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
            Circle().fill(color)
        case .stroke:
            Circle().stroke(color, lineWidth: strokeWidth)
        case .dotted:
            Circle().stroke(
                color,
                style: StrokeStyle(lineWidth: strokeWidth, dash: [6])
            )
        case .transparent:
            Circle().fill(color.opacity(0.3))
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
            RoundedRectangle(cornerRadius: cornerRadius).fill(color)
        case .stroke:
            RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: strokeWidth)
        case .dotted:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, style: StrokeStyle(lineWidth: strokeWidth, dash: [6]))
        case .transparent:
            RoundedRectangle(cornerRadius: cornerRadius).fill(color.opacity(0.3))
        }
    }
}

