# MagicCalendar - Binding-Based Architecture

## Overview

The MagicCalendar library has been completely refactored to use SwiftUI's state and binding concepts instead of callback-based listeners. This makes the library more SwiftUI-native and provides better integration with your app's state management.

## Key Changes

### 1. **Mandatory Bindings**
All calendar instances now **require** three mandatory binding parameters:
- `selectedDate: Binding<Date?>` - For single date selection
- `selectedDates: Binding<Set<Date>>` - For multiple date selection  
- `events: Binding<[Date: [CalendarEvent]]>` - For event management

### 2. **No More Callbacks**
The library no longer uses callback-based approaches like:
- ❌ `onDateSelected: ((Date) -> Void)?`  
- ❌ `onDateLongPress: ((Date) -> Void)?`

Instead, all state changes are handled through bindings automatically.

### 3. **State-Driven Architecture**
Your app's state drives the calendar's behavior, making it reactive and predictable.

## Usage Examples

### Basic Implementation

```swift
struct ContentView: View {
    @State private var selectedDate: Date? = nil
    @State private var selectedDates: Set<Date> = []
    @State private var events: [Date: [CalendarEvent]] = [:]
    
    var body: some View {
        CalendarView(
            selectedDate: $selectedDate,
            selectedDates: $selectedDates,
            events: $events
        )
    }
}
```

### Multi-Selection

```swift
CalendarView(
    selectedDate: $selectedDate,
    selectedDates: $selectedDates,
    events: $events,
    configuration: CalendarConfiguration(selectionMode: .multiple)
)

Text("Selected: \(selectedDates.count) dates")
```

### Event Management

```swift
CalendarView(
    selectedDate: $selectedDate,
    selectedDates: $selectedDates,
    events: $events
)
.onChange(of: selectedDate) { date in
    if let date = date {
        addEvent(to: date)
    }
}

func addEvent(to date: Date) {
    let event = CalendarEvent(
        title: "New Event",
        date: date,
        color: .blue
    )
    let normalizedDate = Calendar.current.startOfDay(for: date)
    if events[normalizedDate] == nil {
        events[normalizedDate] = []
    }
    events[normalizedDate]?.append(event)
}
```

## Benefits

### ✅ **SwiftUI Native**
- Uses @State and @Binding properly
- Follows SwiftUI's declarative paradigm
- Integrates seamlessly with SwiftUI's state management

### ✅ **Predictable State**
- All state changes are explicit and trackable
- No hidden side effects from callbacks
- Easy to debug and reason about

### ✅ **Reactive by Design**
- Calendar automatically updates when bindings change
- Two-way data binding works naturally
- Perfect for MVVM architecture

### ✅ **Type Safe**
- Mandatory bindings prevent runtime errors
- Clear API contract
- Better IDE support and autocompletion

## Migration Guide

### Before (Callback-based)
```swift
@StateObject private var viewModel = CalendarViewModel()

CalendarView(viewModel: viewModel) { selectedDate in
    // Handle selection
    handleDateSelection(selectedDate)
}
```

### After (Binding-based)
```swift
@State private var selectedDate: Date? = nil
@State private var selectedDates: Set<Date> = []
@State private var events: [Date: [CalendarEvent]] = [:]

CalendarView(
    selectedDate: $selectedDate,
    selectedDates: $selectedDates,
    events: $events
)
// Selection automatically updates the binding
```

## Configuration Options

All configuration is still available through the `CalendarConfiguration` parameter:

```swift
CalendarView(
    selectedDate: $selectedDate,
    selectedDates: $selectedDates,
    events: $events,
    configuration: CalendarConfiguration(
        selectionMode: .multiple,
        firstDayOfWeek: .monday,
        allowPastSelection: false
    )
)
```

## Conclusion

This binding-based approach makes MagicCalendar a true SwiftUI-first library that integrates seamlessly with your app's state management, providing a more predictable, maintainable, and SwiftUI-native experience.
