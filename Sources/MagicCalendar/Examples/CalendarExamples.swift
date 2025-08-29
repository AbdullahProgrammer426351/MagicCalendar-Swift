import SwiftUI
import Foundation

// MARK: - Example Views

/// Basic calendar example
public struct BasicCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Basic Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events
            )
            .padding()
            
            if let selected = selectedDate {
                Text("Selected: \(DateFormatter.displayFormatter.string(from: selected))")
                    .padding()
            }
        }
    }
}

/// Dark theme calendar example
public struct DarkThemeCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Dark Theme Calendar")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events,
                theme: .dark
            )
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
    }
}

/// Multi-selection calendar example
public struct MultiSelectionCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Multi-Selection Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events,
                configuration: CalendarConfiguration(selectionMode: .multiple)
            )
            .padding()
            
            Text("Selected Dates: \(selectedDates.count)")
                .padding()
        }
    }
}

/// Range selection calendar example
public struct RangeSelectionCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Range Selection Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events,
                configuration: CalendarConfiguration(selectionMode: .range)
            )
            .padding()
            
            if selectedDates.count >= 2 {
                let dates = selectedDates.sorted()
                let range = dates.first!...dates.last!
                Text("Selected Range: \(DateFormatter.displayFormatter.string(from: range.lowerBound)) - \(DateFormatter.displayFormatter.string(from: range.upperBound))")
                    .padding()
            }
        }
    }
}

/// Event calendar example
public struct EventCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Calendar with Events")
                .font(.title2)
                .padding()
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events
            )
            .padding()
            
            Text("Tap dates to add events")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .onAppear {
            addSampleEvents()
        }
        .onChange(of: selectedDate) { newValue in
            if let date = newValue {
                addRandomEvent(to: date)
            }
        }
    }
    
    private func addSampleEvents() {
        let today = Date()
        let calendar = Calendar.current
        
        // Add some sample events
        for i in 1...5 {
            if let eventDate = calendar.date(byAdding: .day, value: i, to: today) {
                let event = CalendarEvent(
                    title: "Sample Event \(i)",
                    date: eventDate,
                    color: EventColor.allCases.randomElement() ?? .blue,
                    type: .event
                )
                let normalizedDate = Calendar.current.startOfDay(for: eventDate)
                if events[normalizedDate] == nil {
                    events[normalizedDate] = []
                }
                events[normalizedDate]?.append(event)
            }
        }
    }
    
    private func addRandomEvent(to date: Date) {
        let event = CalendarEvent(
            title: "Event \(Int.random(in: 1...100))",
            date: date,
            color: EventColor.allCases.randomElement() ?? .blue
        )
        let normalizedDate = Calendar.current.startOfDay(for: date)
        if events[normalizedDate] == nil {
            events[normalizedDate] = []
        }
        events[normalizedDate]?.append(event)
    }
}

/// Custom day view calendar example
public struct CustomDayViewCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Custom Day View Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events
            )
            .customDayView { day, theme in
                CustomDayCell(day: day, theme: theme)
            }
            .padding()
        }
    }
}

/// Custom day cell for the custom day view example
struct CustomDayCell: View {
    let day: CalendarDay
    let theme: CalendarTheme
    
    var body: some View {
        ZStack {
            // Hexagon shape
            HexagonShape()
                .fill(day.isSelected ? theme.colors.selectedBackground : theme.colors.background)
                .overlay(
                    HexagonShape()
                        .stroke(day.isToday ? theme.colors.todayBackground : theme.colors.border, lineWidth: 2)
                )
            
            VStack(spacing: 2) {
                Text(String(day.day))
                    .font(theme.typography.dayFont)
                    .foregroundColor(day.isSelected ? theme.colors.selectedForeground : theme.colors.onBackground)
                
                if !day.events.isEmpty {
                    Circle()
                        .fill(theme.colors.eventIndicator)
                        .frame(width: 4, height: 4)
                }
            }
        }
        .frame(width: theme.sizing.daySize, height: theme.sizing.daySize)
        .opacity(day.isCurrentMonth ? 1.0 : 0.3)
    }
}

/// Hexagon shape for custom day view
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * Double.pi / 3
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}

/// Monday first calendar example
public struct MondayFirstCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Monday First Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events,
                configuration: CalendarConfiguration(firstDayOfWeek: .monday)
            )
            .padding()
        }
    }
}

/// Limited date range calendar example
public struct LimitedDateRangeCalendarExample: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    private let configuration: CalendarConfiguration
    
    public init() {
        let calendar = Calendar.current
        let today = Date()
        let minDate = calendar.date(byAdding: .month, value: -1, to: today)!
        let maxDate = calendar.date(byAdding: .month, value: 2, to: today)!
        
        self.configuration = CalendarConfiguration(
            minimumDate: minDate,
            maximumDate: maxDate
        )
    }
    
    public var body: some View {
        VStack {
            Text("Limited Date Range")
                .font(.title2)
                .padding()
            
            Text("Can only select dates within 3 months")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            CalendarView(
                selectedDate: $selectedDate,
                selectedDates: $selectedDates,
                events: $events,
                configuration: configuration
            )
            .padding()
        }
    }
}

// MARK: - Helper Extensions
extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
