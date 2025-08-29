import Foundation
import SwiftUI

// MARK: - Calendar View Model
@MainActor
public class CalendarViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var currentMonth: CalendarMonth
    public let configuration: CalendarConfiguration
    
    // MARK: - Bindings
    private let selectedDate: Binding<Date?>
    private let selectedDates: Binding<Set<Date>>
    private let events: Binding<[Date: [CalendarEvent]]>
    
    // MARK: - Private Properties
    private let calendar = Calendar.current
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    // MARK: - Initialization
    public init(
        initialDate: Date = Date(),
        selectedDate: Binding<Date?>,
        selectedDates: Binding<Set<Date>>,
        events: Binding<[Date: [CalendarEvent]]>,
        configuration: CalendarConfiguration = CalendarConfiguration()
    ) {
        self.selectedDate = selectedDate
        self.selectedDates = selectedDates
        self.events = events
        self.configuration = configuration
        self.currentMonth = CalendarMonth(date: initialDate, weeks: [], monthName: "", year: 0)
        generateMonth(for: initialDate)
    }
    
    // MARK: - Public Methods
    
    /// Navigate to the next month
    public func nextMonth() {
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth.date) else { return }
        generateMonth(for: nextMonth)
    }
    
    /// Navigate to the previous month
    public func previousMonth() {
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth.date) else { return }
        generateMonth(for: previousMonth)
    }
    
    /// Navigate to a specific date
    public func navigate(to date: Date) {
        generateMonth(for: date)
    }
    
    /// Navigate to today
    public func goToToday() {
        generateMonth(for: Date())
    }
    
    /// Select a date based on configuration
    public func selectDate(_ date: Date) {
        guard canSelectDate(date) else { return }
        
        switch configuration.selectionMode {
        case .single:
            selectedDate.wrappedValue = date
            selectedDates.wrappedValue = [date]
        case .multiple:
            var currentDates = selectedDates.wrappedValue
            if currentDates.contains(date) {
                currentDates.remove(date)
            } else {
                currentDates.insert(date)
            }
            selectedDates.wrappedValue = currentDates
        case .range:
            handleRangeSelection(date)
        case .none:
            break
        }
        
        // Regenerate current month to reflect selection changes
        generateMonth(for: currentMonth.date)
    }
    
    /// Add an event to a specific date
    public func addEvent(_ event: CalendarEvent, to date: Date) {
        let normalizedDate = calendar.startOfDay(for: date)
        var currentEvents = events.wrappedValue
        if currentEvents[normalizedDate] == nil {
            currentEvents[normalizedDate] = []
        }
        currentEvents[normalizedDate]?.append(event)
        events.wrappedValue = currentEvents
        
        // Regenerate current month to reflect event changes
        generateMonth(for: currentMonth.date)
    }
    
    /// Remove an event from a specific date
    public func removeEvent(_ event: CalendarEvent, from date: Date) {
        let normalizedDate = calendar.startOfDay(for: date)
        var currentEvents = events.wrappedValue
        currentEvents[normalizedDate]?.removeAll { $0.id == event.id }
        if currentEvents[normalizedDate]?.isEmpty == true {
            currentEvents[normalizedDate] = nil
        }
        events.wrappedValue = currentEvents
        
        // Regenerate current month to reflect event changes
        generateMonth(for: currentMonth.date)
    }
    
    /// Get events for a specific date
    public func events(for date: Date) -> [CalendarEvent] {
        let normalizedDate = calendar.startOfDay(for: date)
        return events.wrappedValue[normalizedDate] ?? []
    }
    
    // MARK: - Private Methods
    
    private func generateMonth(for date: Date) {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let monthName = monthFormatter.string(from: date)
        
        // Get first day of the month
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            return
        }
        
        // Calculate the starting date for the calendar grid
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let firstDayOfWeekValue = configuration.firstDayOfWeek.rawValue
        
        var daysFromStart = firstDayWeekday - firstDayOfWeekValue
        if daysFromStart < 0 {
            daysFromStart += 7
        }
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysFromStart, to: firstDayOfMonth) else {
            return
        }
        
        // Generate calendar weeks
        var weeks: [[CalendarDay]] = []
        var currentDate = startDate
        
        for weekIndex in 0..<6 { // Maximum 6 weeks for a month view
            var week: [CalendarDay] = []
            
            for _ in 0..<7 {
                let dayComponent = calendar.component(.day, from: currentDate)
                let monthComponent = calendar.component(.month, from: currentDate)
                let isCurrentMonth = monthComponent == month
                let isToday = calendar.isDate(currentDate, inSameDayAs: Date())
                let isSelected = selectedDates.wrappedValue.contains(where: { calendar.isDate($0, inSameDayAs: currentDate) })
                let isWeekend = calendar.isDateInWeekend(currentDate)
                let dayEvents = events(for: currentDate)
                
                let calendarDay = CalendarDay(
                    date: currentDate,
                    day: dayComponent,
                    isCurrentMonth: isCurrentMonth,
                    isToday: isToday,
                    isSelected: isSelected,
                    isWeekend: isWeekend,
                    events: dayEvents
                )
                
                week.append(calendarDay)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }
            
            weeks.append(week)
            
            // Stop if we've covered all days of the current month and we're in a new month
            if weekIndex > 0 && week.allSatisfy({ !$0.isCurrentMonth }) {
                break
            }
        }
        
        currentMonth = CalendarMonth(
            date: date,
            weeks: weeks,
            monthName: monthName,
            year: year
        )
    }
    
    private func canSelectDate(_ date: Date) -> Bool {
        let now = Date()
        
        // Check if past selection is allowed
        if !configuration.allowPastSelection && calendar.compare(date, to: now, toGranularity: .day) == .orderedAscending {
            return false
        }
        
        // Check if future selection is allowed
        if !configuration.allowFutureSelection && calendar.compare(date, to: now, toGranularity: .day) == .orderedDescending {
            return false
        }
        
        // Check minimum date constraint
        if let minimumDate = configuration.minimumDate,
           calendar.compare(date, to: minimumDate, toGranularity: .day) == .orderedAscending {
            return false
        }
        
        // Check maximum date constraint
        if let maximumDate = configuration.maximumDate,
           calendar.compare(date, to: maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        
        return true
    }
    
    private func handleRangeSelection(_ date: Date) {
        var currentDates = selectedDates.wrappedValue
        
        if currentDates.isEmpty {
            // First selection in range
            currentDates.insert(date)
        } else if currentDates.count == 1 {
            // Second selection - complete the range
            let existingDate = currentDates.first!
            let startDate = min(date, existingDate)
            let endDate = max(date, existingDate)
            
            currentDates.removeAll()
            var currentDate = startDate
            
            while calendar.compare(currentDate, to: endDate, toGranularity: .day) != .orderedDescending {
                currentDates.insert(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }
        } else {
            // Reset range selection
            currentDates = [date]
        }
        
        selectedDates.wrappedValue = currentDates
    }
}

// MARK: - Helper Extensions
extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
