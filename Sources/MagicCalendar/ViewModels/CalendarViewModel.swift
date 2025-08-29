import Foundation
import SwiftUI

// MARK: - Calendar View Model
@MainActor
public class CalendarViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var currentMonth: CalendarMonth
    @Published public var selectedDates: Set<Date> = []
    @Published public var events: [Date: [CalendarEvent]] = [:]
    @Published public var configuration: CalendarConfiguration
    
    // MARK: - Private Properties
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    // MARK: - Initialization
    public init(
        initialDate: Date = Date(),
        configuration: CalendarConfiguration = CalendarConfiguration()
    ) {
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
            selectedDates = [date]
        case .multiple:
            if selectedDates.contains(date) {
                selectedDates.remove(date)
            } else {
                selectedDates.insert(date)
            }
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
        if events[normalizedDate] == nil {
            events[normalizedDate] = []
        }
        events[normalizedDate]?.append(event)
        
        // Regenerate current month to reflect event changes
        generateMonth(for: currentMonth.date)
    }
    
    /// Remove an event from a specific date
    public func removeEvent(_ event: CalendarEvent, from date: Date) {
        let normalizedDate = calendar.startOfDay(for: date)
        events[normalizedDate]?.removeAll { $0.id == event.id }
        if events[normalizedDate]?.isEmpty == true {
            events[normalizedDate] = nil
        }
        
        // Regenerate current month to reflect event changes
        generateMonth(for: currentMonth.date)
    }
    
    /// Get events for a specific date
    public func events(for date: Date) -> [CalendarEvent] {
        let normalizedDate = calendar.startOfDay(for: date)
        return events[normalizedDate] ?? []
    }
    
    /// Update configuration
    public func updateConfiguration(_ newConfiguration: CalendarConfiguration) {
        configuration = newConfiguration
        selectedDates.removeAll() // Clear selections when configuration changes
        generateMonth(for: currentMonth.date)
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
                let isSelected = selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: currentDate) })
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
        if selectedDates.isEmpty {
            // First selection in range
            selectedDates.insert(date)
        } else if selectedDates.count == 1 {
            // Second selection - complete the range
            let existingDate = selectedDates.first!
            let startDate = min(date, existingDate)
            let endDate = max(date, existingDate)
            
            selectedDates.removeAll()
            var currentDate = startDate
            
            while calendar.compare(currentDate, to: endDate, toGranularity: .day) != .orderedDescending {
                selectedDates.insert(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }
        } else {
            // Reset range selection
            selectedDates = [date]
        }
    }
}

// MARK: - Helper Extensions
extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
