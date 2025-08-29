# Changelog

All notable changes to MagicCalendar will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-08-29

### Added
- **Core Calendar Components**
  - `CalendarView` - Main calendar view with full customization
  - `CalendarViewModel` - Observable object for state management
  - `DayView` - Individual day cell component
  - Modular architecture with separate views for header, weekdays, months, weeks

- **Data Models**
  - `CalendarDay` - Represents a single day with state and events
  - `CalendarMonth` - Represents a month with weeks and metadata
  - `CalendarEvent` - Event model with title, date, color, and type
  - `CalendarConfiguration` - Configuration options for calendar behavior
  - All models conform to `Sendable` for concurrency safety

- **Selection Modes**
  - Single date selection
  - Multiple date selection
  - Date range selection
  - No selection mode

- **Event Management**
  - Add, remove, and display events on calendar
  - Color-coded event indicators
  - Support for multiple events per day
  - Event types: event, reminder, birthday, holiday, meeting
  - Event colors: red, blue, green, orange, purple, pink, yellow, gray

- **Theming System**
  - Comprehensive theming with `CalendarTheme`
  - Built-in themes: Default, Dark, Minimal, Colorful
  - Customizable colors, typography, spacing, and sizing
  - Theme-aware event colors and indicators

- **Configuration Options**
  - Configurable first day of week (Sunday/Monday/etc.)
  - Date range restrictions (minimum/maximum dates)
  - Past/future selection control
  - Weekend highlighting

- **Custom Day Views**
  - Support for completely custom day cell rendering
  - Access to day data and theme in custom views
  - Maintain interaction handling with custom views

- **Navigation Features**
  - Previous/next month navigation
  - Navigate to specific dates
  - "Go to today" functionality
  - Animated transitions

- **Examples and Documentation**
  - Comprehensive examples demonstrating all features
  - Complete API documentation
  - Usage examples for all configuration options
  - Demo app showcasing various use cases

- **Testing**
  - Complete test suite using Swift Testing framework
  - Tests for all major components and functionality
  - Async/await support with MainActor compliance

### Technical Details
- **Platform Support**: iOS 16.0+, macOS 13.0+
- **Swift Version**: Swift 6.0+
- **Architecture**: MVVM with SwiftUI and Combine
- **Concurrency**: Full async/await and Sendable support
- **Package Manager**: Swift Package Manager

### Inspired By
- Android Jetpack Compose calendar implementations
- Material Design calendar patterns
- Native iOS calendar behaviors

### Breaking Changes
- N/A (Initial release)

### Deprecated
- N/A (Initial release)

### Removed
- N/A (Initial release)

### Fixed
- N/A (Initial release)

### Security
- N/A (Initial release)
