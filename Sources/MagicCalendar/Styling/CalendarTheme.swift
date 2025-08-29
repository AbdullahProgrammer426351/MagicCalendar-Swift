import SwiftUI
import Foundation

// MARK: - Calendar Theme
public struct CalendarTheme: Sendable {
    
    // MARK: - Colors
    public struct Colors: Sendable {
        public let primary: Color
        public let secondary: Color
        public let background: Color
        public let surface: Color
        public let onPrimary: Color
        public let onSecondary: Color
        public let onBackground: Color
        public let onSurface: Color
        public let selectedBackground: Color
        public let selectedForeground: Color
        public let todayBackground: Color
        public let todayForeground: Color
        public let weekendForeground: Color
        public let disabledForeground: Color
        public let eventIndicator: Color
        public let border: Color
        
        public init(
            primary: Color = .blue,
            secondary: Color = .gray,
            background: Color = .clear,
            surface: Color = .clear,
            onPrimary: Color = .white,
            onSecondary: Color = .black,
            onBackground: Color = .primary,
            onSurface: Color = .primary,
            selectedBackground: Color = .blue,
            selectedForeground: Color = .white,
            todayBackground: Color = .red,
            todayForeground: Color = .white,
            weekendForeground: Color = .red,
            disabledForeground: Color = .gray,
            eventIndicator: Color = .green,
            border: Color = .gray.opacity(0.3)
        ) {
            self.primary = primary
            self.secondary = secondary
            self.background = background
            self.surface = surface
            self.onPrimary = onPrimary
            self.onSecondary = onSecondary
            self.onBackground = onBackground
            self.onSurface = onSurface
            self.selectedBackground = selectedBackground
            self.selectedForeground = selectedForeground
            self.todayBackground = todayBackground
            self.todayForeground = todayForeground
            self.weekendForeground = weekendForeground
            self.disabledForeground = disabledForeground
            self.eventIndicator = eventIndicator
            self.border = border
        }
    }
    
    // MARK: - Typography
    public struct Typography: Sendable {
        public let headerFont: Font
        public let dayFont: Font
        public let weekdayFont: Font
        public let eventFont: Font
        
        public init(
            headerFont: Font = .title2.bold(),
            dayFont: Font = .body,
            weekdayFont: Font = .caption.bold(),
            eventFont: Font = .caption2
        ) {
            self.headerFont = headerFont
            self.dayFont = dayFont
            self.weekdayFont = weekdayFont
            self.eventFont = eventFont
        }
    }
    
    // MARK: - Spacing
    public struct Spacing: Sendable {
        public let small: CGFloat
        public let medium: CGFloat
        public let large: CGFloat
        public let daySpacing: CGFloat
        public let weekSpacing: CGFloat
        public let headerSpacing: CGFloat
        
        public init(
            small: CGFloat = 4,
            medium: CGFloat = 8,
            large: CGFloat = 16,
            daySpacing: CGFloat = 2,
            weekSpacing: CGFloat = 8,
            headerSpacing: CGFloat = 16
        ) {
            self.small = small
            self.medium = medium
            self.large = large
            self.daySpacing = daySpacing
            self.weekSpacing = weekSpacing
            self.headerSpacing = headerSpacing
        }
    }
    
    // MARK: - Sizing
    public struct Sizing: Sendable {
        public let daySize: CGFloat
        public let eventIndicatorSize: CGFloat
        public let cornerRadius: CGFloat
        public let borderWidth: CGFloat
        
        public init(
            daySize: CGFloat = 40,
            eventIndicatorSize: CGFloat = 6,
            cornerRadius: CGFloat = 8,
            borderWidth: CGFloat = 1
        ) {
            self.daySize = daySize
            self.eventIndicatorSize = eventIndicatorSize
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
        }
    }
    
    // MARK: - Properties
    public let colors: Colors
    public let typography: Typography
    public let spacing: Spacing
    public let sizing: Sizing
    
    // MARK: - Initialization
    public init(
        colors: Colors = Colors(),
        typography: Typography = Typography(),
        spacing: Spacing = Spacing(),
        sizing: Sizing = Sizing()
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.sizing = sizing
    }
}

// MARK: - Predefined Themes
extension CalendarTheme {
    
    public static let `default` = CalendarTheme()
    
    public static let dark = CalendarTheme(
        colors: Colors(
            primary: .white,
            secondary: .gray,
            background: .black,
            surface: .gray.opacity(0.1),
            onPrimary: .black,
            onSecondary: .white,
            onBackground: .white,
            onSurface: .white,
            selectedBackground: .blue,
            selectedForeground: .white,
            todayBackground: .orange,
            todayForeground: .white,
            weekendForeground: .red.opacity(0.8),
            disabledForeground: .gray.opacity(0.5),
            eventIndicator: .green,
            border: .gray.opacity(0.3)
        )
    )
    
    public static let minimal = CalendarTheme(
        colors: Colors(
            primary: .black,
            secondary: .gray,
            background: .clear,
            surface: .clear,
            selectedBackground: .black,
            selectedForeground: .white,
            todayBackground: .clear,
            todayForeground: .black,
            weekendForeground: .black,
            disabledForeground: .gray.opacity(0.5),
            eventIndicator: .black,
            border: .clear
        ),
        spacing: Spacing(
            daySpacing: 1,
            weekSpacing: 4,
            headerSpacing: 12
        ),
        sizing: Sizing(
            cornerRadius: 0,
            borderWidth: 0
        )
    )
    
    public static let colorful = CalendarTheme(
        colors: Colors(
            primary: .purple,
            secondary: .pink,
            selectedBackground: .purple,
            selectedForeground: .white,
            todayBackground: .pink,
            todayForeground: .white,
            weekendForeground: .purple.opacity(0.7),
            eventIndicator: .orange
        ),
        sizing: Sizing(
            cornerRadius: 12
        )
    )
}

// MARK: - Event Color Mapping
extension EventColor {
    public func color(for theme: CalendarTheme) -> Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .yellow: return .yellow
        case .gray: return .gray
        }
    }
}

// MARK: - Calendar Style Modifiers
public struct CalendarDayStyle {
    public let backgroundColor: Color
    public let foregroundColor: Color
    public let font: Font
    public let cornerRadius: CGFloat
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let size: CGFloat
    
    public init(
        backgroundColor: Color = .clear,
        foregroundColor: Color = .primary,
        font: Font = .body,
        cornerRadius: CGFloat = 8,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        size: CGFloat = 40
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.size = size
    }
    
    public static func from(theme: CalendarTheme, day: CalendarDay) -> CalendarDayStyle {
        var backgroundColor = theme.colors.background
        var foregroundColor = theme.colors.onBackground
        
        if day.isSelected {
            backgroundColor = theme.colors.selectedBackground
            foregroundColor = theme.colors.selectedForeground
        } else if day.isToday {
            backgroundColor = theme.colors.todayBackground
            foregroundColor = theme.colors.todayForeground
        } else if !day.isCurrentMonth {
            foregroundColor = theme.colors.disabledForeground
        } else if day.isWeekend {
            foregroundColor = theme.colors.weekendForeground
        }
        
        return CalendarDayStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            font: theme.typography.dayFont,
            cornerRadius: theme.sizing.cornerRadius,
            borderColor: theme.colors.border,
            borderWidth: day.isToday && !day.isSelected ? theme.sizing.borderWidth : 0,
            size: theme.sizing.daySize
        )
    }
}
