//
//  File.swift
//  MagicCalendar
//
//  Created by APPLE on 31/08/2025.
//

import SwiftUI

struct CalendarHeader: View {
    let currentMonth: Date
    let headerStyle: HeaderStyle
    let prevIcon: CalendarIcon
    let nextIcon: CalendarIcon
    let onPrevious: () -> Void
    let onNext: () -> Void
    let accentColor: Color
    let headerFontStyle: HeaderFontStyle
    
    var body: some View {
        switch headerStyle {
        case .titleOnStart:
            HStack {
                CalendarTitle(currentMonth: currentMonth,
                              headerFontStyle: headerFontStyle,
                              textColor: accentColor)
                Spacer()
                NavigationButtons(prevIcon: prevIcon, nextIcon: nextIcon,
                                  onPrevious: onPrevious, onNext: onNext,
                                  accentColor: accentColor)
            }
            
        case .titleOnEnd:
            HStack {
                NavigationButtons(prevIcon: prevIcon, nextIcon: nextIcon,
                                  onPrevious: onPrevious, onNext: onNext,
                                  accentColor: accentColor)
                Spacer()
                CalendarTitle(currentMonth: currentMonth,
                              headerFontStyle: headerFontStyle,
                              textColor: accentColor)
            }
            
        case .titleInCenter:
            HStack {
                Button(action: onPrevious) {
                    RenderIcon(icon: prevIcon, tint: accentColor)
                }
                Spacer()
                CalendarTitle(currentMonth: currentMonth,
                              headerFontStyle: headerFontStyle,
                              textColor: accentColor)
                Spacer()
                Button(action: onNext) {
                    RenderIcon(icon: nextIcon, tint: accentColor)
                }
            }
            
        case .withoutButtons:
            HStack {
                Spacer()
                CalendarTitle(currentMonth: currentMonth,
                              headerFontStyle: headerFontStyle,
                              textColor: accentColor)
                Spacer()
            }
        }
    }
}

struct CalendarTitle: View {
    let currentMonth: Date
    let headerFontStyle: HeaderFontStyle
    let textColor: Color
    
    var body: some View {
        Text(currentMonth, formatter: monthFormatter)
            .font(headerFontStyle.font.weight(headerFontStyle.fontWeight))
            .foregroundColor(textColor)
            .padding(8)
    }
    
    private var monthFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        f.locale = Locale.current
        return f
    }
}

struct NavigationButtons: View {
    let prevIcon: CalendarIcon
    let nextIcon: CalendarIcon
    let onPrevious: () -> Void
    let onNext: () -> Void
    let accentColor: Color
    
    var body: some View {
        HStack {
            Button(action: onPrevious) {
                RenderIcon(icon: prevIcon, tint: accentColor)
            }
            Button(action: onNext) {
                RenderIcon(icon: nextIcon, tint: accentColor)
            }
        }
    }
}

struct RenderIcon: View {
    let icon: CalendarIcon
    let tint: Color
    
    var body: some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .foregroundColor(tint)
        case .asset(let name):
            Image(name)
                .renderingMode(.template)
                .foregroundColor(tint)
        case .customView(let content):
            content()
        case .image(let img):
            img
        }
    }
}
