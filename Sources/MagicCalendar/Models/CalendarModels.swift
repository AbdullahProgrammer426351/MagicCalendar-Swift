import Foundation

// MARK: - Calendar Day Model
public struct CalendarDay: Identifiable, Equatable, Hashable, Sendable {
    public let id = UUID()
    public let date: Date
    public let day: Int
    public let isCurrentMonth: Bool
    public let isToday: Bool
    public let isSelected: Bool
    public let isWeekend: Bool
    public let events: [CalendarEvent]
    
    public init(
        date: Date,
        day: Int,
        isCurrentMonth: Bool,
        isToday: Bool = false,
        isSelected: Bool = false,
        isWeekend: Bool = false,
        events: [CalendarEvent] = []
    ) {
        self.date = date
        self.day = day
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
        self.isSelected = isSelected
        self.isWeekend = isWeekend
        self.events = events
    }
}

// MARK: - Calendar Event Model
public struct CalendarEvent: Identifiable, Equatable, Hashable, Sendable {
    public let id = UUID()
    public let title: String
    public let date: Date
    public let color: EventColor
    public let type: EventType
    
    public init(title: String, date: Date, color: EventColor = .blue, type: EventType = .event) {
        self.title = title
        self.date = date
        self.color = color
        self.type = type
    }
}

// MARK: - Event Color
public enum EventColor: CaseIterable, Sendable {
    case red, blue, green, orange, purple, pink, yellow, gray
    
    public var name: String {
        switch self {
        case .red: return "red"
        case .blue: return "blue"
        case .green: return "green"
        case .orange: return "orange"
        case .purple: return "purple"
        case .pink: return "pink"
        case .yellow: return "yellow"
        case .gray: return "gray"
        }
    }
}

// MARK: - Event Type
public enum EventType: CaseIterable, Sendable {
    case event, reminder, birthday, holiday, meeting
    
    public var name: String {
        switch self {
        case .event: return "Event"
        case .reminder: return "Reminder"
        case .birthday: return "Birthday"
        case .holiday: return "Holiday"
        case .meeting: return "Meeting"
        }
    }
}

// MARK: - Calendar Month Model
public struct CalendarMonth: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let date: Date
    public let weeks: [[CalendarDay]]
    public let monthName: String
    public let year: Int
    
    public init(date: Date, weeks: [[CalendarDay]], monthName: String, year: Int) {
        self.date = date
        self.weeks = weeks
        self.monthName = monthName
        self.year = year
    }
}

// MARK: - Calendar Selection Mode
public enum CalendarSelectionMode: Sendable {
    case single
    case multiple
    case range
    case none
}

// MARK: - Calendar Display Mode
public enum CalendarDisplayMode: Sendable {
    case month
    case week
    case agenda
}

// MARK: - Week Day
public enum WeekDay: Int, CaseIterable, Sendable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    public var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
    
    public var fullName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

// MARK: - Calendar Configuration
public struct CalendarConfiguration: Sendable {
    public let selectionMode: CalendarSelectionMode
    public let displayMode: CalendarDisplayMode
    public let firstDayOfWeek: WeekDay
    public let showWeekNumbers: Bool
    public let allowPastSelection: Bool
    public let allowFutureSelection: Bool
    public let minimumDate: Date?
    public let maximumDate: Date?
    
    public init(
        selectionMode: CalendarSelectionMode = .single,
        displayMode: CalendarDisplayMode = .month,
        firstDayOfWeek: WeekDay = .sunday,
        showWeekNumbers: Bool = false,
        allowPastSelection: Bool = true,
        allowFutureSelection: Bool = true,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil
    ) {
        self.selectionMode = selectionMode
        self.displayMode = displayMode
        self.firstDayOfWeek = firstDayOfWeek
        self.showWeekNumbers = showWeekNumbers
        self.allowPastSelection = allowPastSelection
        self.allowFutureSelection = allowFutureSelection
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }
}
