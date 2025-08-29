import Testing
import Foundation
@testable import MagicCalendar

@Test("Calendar View Model Initialization")
@MainActor
func testCalendarViewModelInitialization() async throws {
    // Create bindings for testing
    var selectedDate: Date? = nil
    var selectedDates: Set<Date> = []
    var events: [Date: [CalendarEvent]] = [:]
    
    let viewModel = CalendarViewModel(
        selectedDate: .constant(selectedDate),
        selectedDates: .constant(selectedDates),
        events: .constant(events)
    )
    
    #expect(viewModel.currentMonth.weeks.count > 0)
    #expect(viewModel.configuration.selectionMode == .single)
}

@Test("Calendar Configuration")
func testCalendarConfiguration() async throws {
    let config = CalendarConfiguration(
        selectionMode: .multiple,
        firstDayOfWeek: .monday,
        allowPastSelection: false
    )
    
    #expect(config.selectionMode == .multiple)
    #expect(config.firstDayOfWeek == .monday)
    #expect(config.allowPastSelection == false)
}

@Test("Calendar Event Creation")
func testCalendarEvent() async throws {
    let event = CalendarEvent(
        title: "Test Event",
        date: Date(),
        color: .blue,
        type: .meeting
    )
    
    #expect(event.title == "Test Event")
    #expect(event.color == .blue)
    #expect(event.type == .meeting)
}

@Test("Calendar Theme Properties")
func testCalendarTheme() async throws {
    let theme = CalendarTheme.dark
    #expect(theme.colors.primary != theme.colors.secondary)
    #expect(theme.typography.headerFont != theme.typography.dayFont)
    #expect(theme.spacing.small < theme.spacing.medium)
    #expect(theme.sizing.daySize > 0)
}

@Test("WeekDay Enum Properties")
func testWeekDayEnum() async throws {
    #expect(WeekDay.monday.shortName == "Mon")
    #expect(WeekDay.sunday.fullName == "Sunday")
    #expect(WeekDay.friday.rawValue == 6)
    #expect(WeekDay.allCases.count == 7)
}

@Test("Event Color Mapping")
func testEventColorMapping() async throws {
    let redColor = EventColor.red
    #expect(redColor.name == "red")
    #expect(EventColor.allCases.count == 8)
}

@Test("Event Type Properties")
func testEventType() async throws {
    #expect(EventType.meeting.name == "Meeting")
    #expect(EventType.birthday.name == "Birthday")
    #expect(EventType.allCases.count == 5)
}

@Test("Calendar Day Creation")
func testCalendarDay() async throws {
    let day = CalendarDay(
        date: Date(),
        day: 15,
        isCurrentMonth: true,
        isToday: true,
        isSelected: false,
        isWeekend: false
    )
    
    #expect(day.day == 15)
    #expect(day.isCurrentMonth == true)
    #expect(day.isToday == true)
    #expect(day.isSelected == false)
    #expect(day.events.isEmpty)
}

@Test("MagicCalendar Namespace")
func testMagicCalendarNamespace() async throws {
    #expect(MagicCalendar.name == "MagicCalendar")
    #expect(MagicCalendar.version == "1.0.0")
}
