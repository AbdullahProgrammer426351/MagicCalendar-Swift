import SwiftUI

// MARK: - Main Calendar View
public struct CalendarView: View {
    @ObservedObject private var viewModel: CalendarViewModel
    private let theme: CalendarTheme
    private let onDateSelected: ((Date) -> Void)?
    private let onDateLongPress: ((Date) -> Void)?
    private let customDayView: ((CalendarDay, CalendarTheme) -> AnyView)?
    
    public init(
        viewModel: CalendarViewModel,
        theme: CalendarTheme = .default,
        onDateSelected: ((Date) -> Void)? = nil,
        onDateLongPress: ((Date) -> Void)? = nil,
        customDayView: ((CalendarDay, CalendarTheme) -> AnyView)? = nil
    ) {
        self.viewModel = viewModel
        self.theme = theme
        self.onDateSelected = onDateSelected
        self.onDateLongPress = onDateLongPress
        self.customDayView = customDayView
    }
    
    public var body: some View {
        VStack(spacing: theme.spacing.medium) {
            CalendarHeaderView(
                viewModel: viewModel,
                theme: theme
            )
            
            WeekdayHeaderView(
                configuration: viewModel.configuration,
                theme: theme
            )
            
            MonthView(
                month: viewModel.currentMonth,
                theme: theme,
                onDateSelected: { date in
                    viewModel.selectDate(date)
                    onDateSelected?(date)
                },
                onDateLongPress: onDateLongPress,
                customDayView: customDayView
            )
        }
        .padding(theme.spacing.medium)
        .background(theme.colors.background)
    }
}

// MARK: - Calendar Header View
struct CalendarHeaderView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let theme: CalendarTheme
    
    var body: some View {
        HStack {
            Button(action: viewModel.previousMonth) {
                Image(systemName: "chevron.left")
                    .font(theme.typography.headerFont)
                    .foregroundColor(theme.colors.primary)
            }
            
            Spacer()
            
            VStack(spacing: theme.spacing.small) {
                Text(viewModel.currentMonth.monthName)
                    .font(theme.typography.headerFont)
                    .foregroundColor(theme.colors.onBackground)
                
                Text(String(viewModel.currentMonth.year))
                    .font(theme.typography.weekdayFont)
                    .foregroundColor(theme.colors.secondary)
            }
            
            Spacer()
            
            Button(action: viewModel.nextMonth) {
                Image(systemName: "chevron.right")
                    .font(theme.typography.headerFont)
                    .foregroundColor(theme.colors.primary)
            }
        }
        .padding(.horizontal, theme.spacing.medium)
    }
}

// MARK: - Weekday Header View
struct WeekdayHeaderView: View {
    let configuration: CalendarConfiguration
    let theme: CalendarTheme
    
    private var weekdays: [WeekDay] {
        let days = WeekDay.allCases
        let firstDayIndex = days.firstIndex(of: configuration.firstDayOfWeek) ?? 0
        return Array(days[firstDayIndex...]) + Array(days[..<firstDayIndex])
    }
    
    var body: some View {
        HStack(spacing: theme.spacing.daySpacing) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday.shortName)
                    .font(theme.typography.weekdayFont)
                    .foregroundColor(theme.colors.secondary)
                    .frame(width: theme.sizing.daySize, height: theme.sizing.daySize * 0.6)
            }
        }
    }
}

// MARK: - Month View
struct MonthView: View {
    let month: CalendarMonth
    let theme: CalendarTheme
    let onDateSelected: (Date) -> Void
    let onDateLongPress: ((Date) -> Void)?
    let customDayView: ((CalendarDay, CalendarTheme) -> AnyView)?
    
    var body: some View {
        VStack(spacing: theme.spacing.weekSpacing) {
            ForEach(month.weeks.indices, id: \.self) { weekIndex in
                WeekView(
                    week: month.weeks[weekIndex],
                    theme: theme,
                    onDateSelected: onDateSelected,
                    onDateLongPress: onDateLongPress,
                    customDayView: customDayView
                )
            }
        }
    }
}

// MARK: - Week View
struct WeekView: View {
    let week: [CalendarDay]
    let theme: CalendarTheme
    let onDateSelected: (Date) -> Void
    let onDateLongPress: ((Date) -> Void)?
    let customDayView: ((CalendarDay, CalendarTheme) -> AnyView)?
    
    var body: some View {
        HStack(spacing: theme.spacing.daySpacing) {
            ForEach(week) { day in
                if let customDayView = customDayView {
                    customDayView(day, theme)
                        .onTapGesture {
                            onDateSelected(day.date)
                        }
                        .onLongPressGesture {
                            onDateLongPress?(day.date)
                        }
                } else {
                    DayView(
                        day: day,
                        theme: theme,
                        onTap: {
                            onDateSelected(day.date)
                        },
                        onLongPress: {
                            onDateLongPress?(day.date)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Day View
public struct DayView: View {
    let day: CalendarDay
    let theme: CalendarTheme
    let onTap: () -> Void
    let onLongPress: (() -> Void)?
    
    private var style: CalendarDayStyle {
        CalendarDayStyle.from(theme: theme, day: day)
    }
    
    public init(
        day: CalendarDay,
        theme: CalendarTheme,
        onTap: @escaping () -> Void = {},
        onLongPress: (() -> Void)? = nil
    ) {
        self.day = day
        self.theme = theme
        self.onTap = onTap
        self.onLongPress = onLongPress
    }
    
    public var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                )
            
            VStack(spacing: theme.spacing.small) {
                // Day number
                Text(String(day.day))
                    .font(style.font)
                    .foregroundColor(style.foregroundColor)
                
                // Event indicators
                if !day.events.isEmpty {
                    EventIndicatorsView(
                        events: day.events,
                        theme: theme
                    )
                }
            }
        }
        .frame(width: style.size, height: style.size)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress?()
        }
        .opacity(day.isCurrentMonth ? 1.0 : 0.3)
        .animation(.easeInOut(duration: 0.2), value: day.isSelected)
    }
}

// MARK: - Event Indicators View
struct EventIndicatorsView: View {
    let events: [CalendarEvent]
    let theme: CalendarTheme
    
    private let maxIndicators = 3
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(events.prefix(maxIndicators).indices, id: \.self) { index in
                Circle()
                    .fill(events[index].color.color(for: theme))
                    .frame(width: theme.sizing.eventIndicatorSize, height: theme.sizing.eventIndicatorSize)
            }
            
            if events.count > maxIndicators {
                Text("+\(events.count - maxIndicators)")
                    .font(theme.typography.eventFont)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }
}

// MARK: - Calendar View Modifiers
extension CalendarView {
    
    /// Apply a custom theme to the calendar
    public func theme(_ theme: CalendarTheme) -> CalendarView {
        CalendarView(
            viewModel: viewModel,
            theme: theme,
            onDateSelected: onDateSelected,
            onDateLongPress: onDateLongPress,
            customDayView: customDayView
        )
    }
    
    /// Set custom day view renderer
    public func customDayView<Content: View>(
        @ViewBuilder _ content: @escaping (CalendarDay, CalendarTheme) -> Content
    ) -> CalendarView {
        CalendarView(
            viewModel: viewModel,
            theme: theme,
            onDateSelected: onDateSelected,
            onDateLongPress: onDateLongPress,
            customDayView: { day, theme in
                AnyView(content(day, theme))
            }
        )
    }
}

// MARK: - Convenience Initializers
extension CalendarView {
    
    /// Create a calendar with default settings
    public init() {
        self.init(
            viewModel: CalendarViewModel(),
            theme: .default
        )
    }
    
    /// Create a calendar with custom configuration
    public init(configuration: CalendarConfiguration, theme: CalendarTheme = .default) {
        self.init(
            viewModel: CalendarViewModel(configuration: configuration),
            theme: theme
        )
    }
}
