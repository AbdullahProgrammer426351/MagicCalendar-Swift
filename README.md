# MagicCalendar

A flexible and highly customizable SwiftUI calendar library inspired by Android's Jetpack Compose calendar implementations. MagicCalendar provides a comprehensive solution for displaying calendars with support for various selection modes, custom themes, event management, and complete customization flexibility.

## Features

✨ **Flexible Date Selection**
- Single date selection
- Multiple date selection 
- Date range selection
- No selection mode

🎨 **Customizable Themes**
- Built-in themes (Default, Dark, Minimal, Colorful)
- Fully customizable color schemes
- Typography customization
- Spacing and sizing controls

📅 **Event Management**
- Add, remove, and display events
- Color-coded event indicators
- Multiple events per date
- Event types and categories

⚙️ **Configuration Options**
- Configurable first day of week
- Date range restrictions
- Past/future selection control
- Weekend highlighting

🛠 **Custom Day Views**
- Complete day cell customization
- Custom shapes and layouts
- Animation support
- Interaction handling

## Installation

### Swift Package Manager

Add MagicCalendar to your project using Swift Package Manager:

1. In Xcode, go to File → Add Package Dependencies
2. Enter the repository URL
3. Select the version you want to use
4. Click Add Package

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/MagicCalendar.git", from: "1.0.0")
]
```

## Quick Start

### Basic Calendar

```swift
import SwiftUI
import MagicCalendar

struct ContentView: View {
    var body: some View {
        CalendarView()
    }
}
```

### Calendar with Date Selection

```swift
import SwiftUI
import MagicCalendar

struct ContentView: View {
    var body: some View {
        CalendarView { selectedDate in
            print("Selected date: \(selectedDate)")
        }
    }
}
```

### Dark Theme Calendar

```swift
CalendarView()
    .theme(.dark)
```

## Advanced Usage

### Multi-Selection Calendar

```swift
@StateObject private var viewModel = CalendarViewModel(
    configuration: CalendarConfiguration(selectionMode: .multiple)
)

var body: some View {
    CalendarView(
        viewModel: viewModel,
        onDateSelected: { date in
            // Handle multi-selection
        }
    )
}
```

### Range Selection Calendar

```swift
@StateObject private var viewModel = CalendarViewModel(
    configuration: CalendarConfiguration(selectionMode: .range)
)

var body: some View {
    CalendarView(viewModel: viewModel) { date in
        // Handle range selection
        if viewModel.selectedDates.count == 2 {
            let dates = Array(viewModel.selectedDates).sorted()
            let range = dates.first!...dates.last!
            print("Selected range: \(range)")
        }
    }
}
```

### Calendar with Events

```swift
@StateObject private var viewModel = CalendarViewModel()

var body: some View {
    CalendarView(viewModel: viewModel)
        .onAppear {
            addSampleEvents()
        }
}

private func addSampleEvents() {
    let event = CalendarEvent(
        title: "Meeting",
        date: Date(),
        color: .blue,
        type: .meeting
    )
    viewModel.addEvent(event, to: Date())
}
```

### Custom Configuration

```swift
let configuration = CalendarConfiguration(
    selectionMode: .single,
    firstDayOfWeek: .monday,
    allowPastSelection: false,
    minimumDate: Date(),
    maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())
)

@StateObject private var viewModel = CalendarViewModel(configuration: configuration)
```

### Custom Themes

```swift
let customTheme = CalendarTheme(
    colors: CalendarTheme.Colors(
        primary: .purple,
        selectedBackground: .purple,
        selectedForeground: .white,
        todayBackground: .orange,
        weekendForeground: .red
    ),
    typography: CalendarTheme.Typography(
        headerFont: .title.bold(),
        dayFont: .callout
    ),
    spacing: CalendarTheme.Spacing(
        daySpacing: 4,
        weekSpacing: 12
    ),
    sizing: CalendarTheme.Sizing(
        daySize: 50,
        cornerRadius: 12
    )
)

CalendarView()
    .theme(customTheme)
```

### Custom Day Views

```swift
CalendarView(viewModel: viewModel)
    .customDayView { day, theme in
        ZStack {
            Circle()
                .fill(day.isSelected ? theme.colors.selectedBackground : Color.clear)
            
            Text(String(day.day))
                .font(theme.typography.dayFont)
                .foregroundColor(day.isSelected ? theme.colors.selectedForeground : theme.colors.onBackground)
        }
        .frame(width: theme.sizing.daySize, height: theme.sizing.daySize)
    }
```

## API Reference

### CalendarView

The main calendar view component.

```swift
public struct CalendarView: View {
    public init(
        viewModel: CalendarViewModel = CalendarViewModel(),
        theme: CalendarTheme = .default,
        onDateSelected: ((Date) -> Void)? = nil,
        onDateLongPress: ((Date) -> Void)? = nil
    )
}
```

### CalendarViewModel

Manages calendar state, navigation, and date selection.

```swift
@MainActor
public class CalendarViewModel: ObservableObject {
    public func nextMonth()
    public func previousMonth()
    public func navigate(to date: Date)
    public func goToToday()
    public func selectDate(_ date: Date)
    public func addEvent(_ event: CalendarEvent, to date: Date)
    public func removeEvent(_ event: CalendarEvent, from date: Date)
    public func events(for date: Date) -> [CalendarEvent]
}
```

### CalendarConfiguration

Configuration options for calendar behavior.

```swift
public struct CalendarConfiguration {
    public let selectionMode: CalendarSelectionMode
    public let firstDayOfWeek: WeekDay
    public let allowPastSelection: Bool
    public let allowFutureSelection: Bool
    public let minimumDate: Date?
    public let maximumDate: Date?
}
```

### CalendarTheme

Comprehensive theming system.

```swift
public struct CalendarTheme {
    public let colors: Colors
    public let typography: Typography
    public let spacing: Spacing
    public let sizing: Sizing
}
```

### CalendarEvent

Event model for calendar events.

```swift
public struct CalendarEvent: Identifiable, Equatable, Hashable {
    public let title: String
    public let date: Date
    public let color: EventColor
    public let type: EventType
}
```

## Built-in Themes

### Default Theme
Standard iOS-style calendar with blue accents.

### Dark Theme
Dark mode compatible theme with appropriate contrast.

### Minimal Theme
Clean, minimal design with subtle styling.

### Colorful Theme
Vibrant theme with purple and pink accents.

## Event Types

- `.event` - General events
- `.reminder` - Reminders
- `.birthday` - Birthday events
- `.holiday` - Holiday events
- `.meeting` - Meeting events

## Event Colors

- `.red`, `.blue`, `.green`, `.orange`, `.purple`, `.pink`, `.yellow`, `.gray`

## Selection Modes

- `.single` - Select one date at a time
- `.multiple` - Select multiple individual dates
- `.range` - Select a continuous range of dates
- `.none` - No selection allowed

## Examples

The package includes comprehensive examples demonstrating various use cases:

- `BasicCalendarExample` - Simple calendar setup
- `DarkThemeCalendarExample` - Dark theme usage
- `MultiSelectionCalendarExample` - Multiple date selection
- `RangeSelectionCalendarExample` - Date range selection
- `EventCalendarExample` - Calendar with events
- `CustomDayViewCalendarExample` - Custom day cell rendering
- `MondayFirstCalendarExample` - Monday as first day of week
- `LimitedDateRangeCalendarExample` - Restricted date selection

## Compatibility

- iOS 16.0+
- macOS 13.0+
- Swift 6.0+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MagicCalendar is available under the MIT license. See the LICENSE file for more info.

## Credits

Inspired by Android's Jetpack Compose calendar implementations, adapted for SwiftUI with additional features and customization options.
