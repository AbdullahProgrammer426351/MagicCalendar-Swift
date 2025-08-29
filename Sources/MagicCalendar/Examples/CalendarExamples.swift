import SwiftUI
import Foundation

// MARK: - Example Views

/// Basic calendar example
public struct BasicCalendarExample: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Basic Calendar")
                .font(.title2)
                .padding()
            
            CalendarView()
                .padding()
        }
    }
}

/// Dark theme calendar example
public struct DarkThemeCalendarExample: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Dark Theme Calendar")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
            
            CalendarView()
                .theme(.dark)
                .padding()
        }
        .background(Color.black.ignoresSafeArea())
    }
}

/// Multi-selection calendar example
public struct MultiSelectionCalendarExample: View {
    @StateObject private var viewModel = CalendarViewModel(
        configuration: CalendarConfiguration(selectionMode: .multiple)
    )
    @State private var selectedDates: [Date] = []
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Multi-Selection Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(
                viewModel: viewModel,
                onDateSelected: { date in
                    if let index = selectedDates.firstIndex(of: date) {
                        selectedDates.remove(at: index)
                    } else {
                        selectedDates.append(date)
                    }
                }
            )
            .padding()
            
            Text("Selected Dates: \\(selectedDates.count)")
                .padding()
        }
    }
}

/// Range selection calendar example
public struct RangeSelectionCalendarExample: View {
    @StateObject private var viewModel = CalendarViewModel(
        configuration: CalendarConfiguration(selectionMode: .range)
    )
    @State private var selectedRange: ClosedRange<Date>?
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Range Selection Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(
                viewModel: viewModel,
                onDateSelected: { date in
                    if viewModel.selectedDates.count == 2 {
                        let dates = Array(viewModel.selectedDates).sorted()
                        selectedRange = dates.first!...dates.last!
                    }
                }
            )
            .padding()
            
            if selectedRange != nil {
                Text("Selected Range: \\(DateFormatter.displayFormatter.string(from: selectedRange!.lowerBound)) - \\(DateFormatter.displayFormatter.string(from: selectedRange!.upperBound))")
                    .padding()
            }
        }
    }
}

/// Event calendar example
public struct EventCalendarExample: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Calendar with Events")
                .font(.title2)
                .padding()
            
            CalendarView(
                viewModel: viewModel,
                onDateSelected: { date in
                    // Add a random event on tap
                    let event = CalendarEvent(
                        title: "Event \\(Int.random(in: 1...100))",
                        date: date,
                        color: EventColor.allCases.randomElement() ?? .blue
                    )
                    viewModel.addEvent(event, to: date)
                }
            )
            .padding()
            
            Text("Tap dates to add events")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .onAppear {
            addSampleEvents()
        }
    }
    
    private func addSampleEvents() {
        let today = Date()
        let calendar = Calendar.current
        
        // Add some sample events
        for i in 1...5 {
            if let eventDate = calendar.date(byAdding: .day, value: i, to: today) {
                let event = CalendarEvent(
                    title: "Sample Event \\(i)",
                    date: eventDate,
                    color: EventColor.allCases.randomElement() ?? .blue,
                    type: .event
                )
                viewModel.addEvent(event, to: eventDate)
            }
        }
    }
}

/// Custom day view calendar example
public struct CustomDayViewCalendarExample: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Custom Day View Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(viewModel: viewModel)
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
    @StateObject private var viewModel = CalendarViewModel(
        configuration: CalendarConfiguration(firstDayOfWeek: .monday)
    )
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Monday First Calendar")
                .font(.title2)
                .padding()
            
            CalendarView(viewModel: viewModel)
                .padding()
        }
    }
}

/// Limited date range calendar example
public struct LimitedDateRangeCalendarExample: View {
    @StateObject private var viewModel: CalendarViewModel
    
    public init() {
        let calendar = Calendar.current
        let today = Date()
        let minDate = calendar.date(byAdding: .month, value: -1, to: today)!
        let maxDate = calendar.date(byAdding: .month, value: 2, to: today)!
        
        let configuration = CalendarConfiguration(
            minimumDate: minDate,
            maximumDate: maxDate
        )
        
        _viewModel = StateObject(wrappedValue: CalendarViewModel(configuration: configuration))
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
            
            CalendarView(viewModel: viewModel)
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
