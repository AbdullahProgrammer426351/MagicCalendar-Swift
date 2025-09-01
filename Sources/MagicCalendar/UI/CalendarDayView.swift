//
//  CalendarDayView.swift
//  MagicCalendar
//
//  Created by APPLE on 31/08/2025.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let events: [Event]
    let isInCurrentMonth: Bool
    let selectedDayTextColor: Color
    let dateBoxStyle: DateBoxStyle
    let selectedDateBoxStyle: DateBoxStyle
    let activeTextColor: Color
    let inactiveTextColor: Color
    let width: CGFloat
    let onClick: () -> Void
    
    var body: some View {
        let day = Calendar.current.component(.day, from: date)
        
        VStack(spacing: 2) {
            ZStack {
                // 1. Event background indicator (only if not selected)
                if let indicator = events.first?.indicator, indicator.isBackgroundType, isInCurrentMonth, !isSelected {
                    EventIndicatorView(indicator: indicator)
                        .frame(width: 38, height: 38)
                } else {
                    // 2. Normal background box (when not selected)
                    if !isSelected {
                        BoxStyleView(style: dateBoxStyle)
                            .frame(width: 38, height: 38)
                    }
                    
                    // 5. Selection overlay (always drawn last so it's above everything else)
                    if isSelected {
                        BoxStyleView(style: selectedDateBoxStyle)
                            .frame(width: 38, height: 38)
                    }
                }
                
                
                
                // 3. Text (day number)
                Text("\(day)")
                    .foregroundColor(
                        isSelected ? selectedDayTextColor :
                            (isInCurrentMonth ? (events.first?.eventColor ?? activeTextColor) : inactiveTextColor)
                    )
                
                // 4. Event icon (center)
                if let icon = events.first?.icon, isInCurrentMonth {
                    EventIconView(eventIcon: icon)
                }
                
                
            }
            .frame(width: width / 7, height: 38)

            
            // ✅ Foreground indicators shown ONLY at bottom
            if let indicator = events.first?.indicator, indicator.isForegroundType, isInCurrentMonth {
                EventIndicatorView(indicator: indicator)
                    .frame(height: 6)
            } else {
                Spacer().frame(height: 6) // keeps alignment consistent
            }
        }
        .frame(width: width / 7)
        .contentShape(Rectangle())
        .onTapGesture {
            if isInCurrentMonth {
                onClick()
            }
        }
    }
}



// MARK: - Helpers

extension EventIndicator {
    var isBackgroundType: Bool {
        switch self {
        case .rectangle, .circle, .ring: return true
        default: return false
        }
    }
    
    var isForegroundType: Bool {
        switch self {
        case .dot, .badge, .bar, .custom: return true
        default: return false
        }
    }
    
    var alignment: Alignment {
        switch self {
        case .badge: return .topTrailing
        default: return .bottom
        }
    }
}

// MARK: - Subviews

struct EventIndicatorView: View {
    let indicator: EventIndicator
    
    var body: some View {
        switch indicator {
        case .dot(let color):
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            
        case .badge(let color, let count):
            Text("\(count)")
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 6)
                .background(color)
                .clipShape(Capsule())
            
        case .bar(let color, let thickness, let radius):
            RoundedRectangle(cornerRadius: radius)
                .fill(color)
                .frame(width: 20, height: thickness)
            
        case .ring(let color, let thickness):
            Circle()
                .stroke(color, lineWidth: thickness)
                .frame(width: 38, height: 38)
            
        case .circle(let color, let strokeWidth, let type):
            Circle()
            // color: Color, strokeWidth: CGFloat = 2, type: CircleType = .filled
                .modifier(CircleTypeModifier(type: type, color: color, strokeWidth: strokeWidth))
            
        case .rectangle(let color, let radius, let strokeWidth, let type):
            RoundedRectangle(cornerRadius: radius)
            // rectangle(color: Color, cornerRadius: CGFloat = 4, strokeWidth: CGFloat = 2, type: RectangleType = .filled)
                .modifier(RectangleTypeModifier(type: type, color: color, cornerRadius: radius, strokeWidth: strokeWidth))
            
        case .custom(let content):
            content()
        }
    }
}

struct EventIconView: View {
    let eventIcon: EventIcon
    
    var body: some View {
        switch eventIcon {
        case .system(let systemName, let pos, let padding):
            ZStack (alignment:pos){
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .padding(padding)
            .frame(width: 38, height: 38, alignment:pos)
            
        case .resource(let name, let pos, let padding):
            ZStack (alignment:pos){
                Image(name)
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .padding(padding)
            .frame(width: 38, height: 38, alignment:pos)
            
        case .custom(let view, let pos, let padding):
            ZStack (alignment:pos){
                view()
            }
            .padding(padding)
            .frame(width: 38, height: 38, alignment:pos)
            
        }
    }
}

// MARK: - Date Box Style

struct BoxStyleView: View {
    let style: DateBoxStyle
    
    var body: some View {
        switch style {
        case .filledCircle(let color):
            Circle().fill(color)
            
        case .filledRectangle(let color, let radius):
            RoundedRectangle(cornerRadius: radius).fill(color)
            
        case .borderedCircle(let color, let width):
            Circle().stroke(color, lineWidth: width)
            
        case .borderedRectangle(let color, let width, let radius):
            RoundedRectangle(cornerRadius: radius).stroke(color, lineWidth: width)
            
        case .customDateBoxStyle(let view):
            view
            
        case .dottedCircle(let dotColor, let dotSize):
            Circle()
                .stroke(
                    dotColor,
                    style: StrokeStyle(
                        lineWidth: dotSize,
                        lineCap: .round,
                        dash: [0, dotSize * 2] // creates dotted effect
                    )
                )
            
        case .dottedRectangle(let dotColor, let dotSize, let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    dotColor,
                    style: StrokeStyle(
                        lineWidth: dotSize,
                        lineCap: .round,
                        dash: [0, dotSize * 2] // spacing between dots
                    )
                )
        case .clear:
            EmptyView()
        }
    }
}

