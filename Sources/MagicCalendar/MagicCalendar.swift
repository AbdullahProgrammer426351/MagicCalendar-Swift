import SwiftUI
import Foundation

/// MagicCalendar - A flexible and customizable SwiftUI calendar library
/// 
/// Features:
/// - Flexible date selection (single, multiple, range)
/// - Customizable themes and styling
/// - Event indicators and management
/// - Configurable first day of week
/// - Custom day view rendering
/// - Built-in animations and interactions
/// 
/// Example Usage:
/// ```swift
/// CalendarView()
///     .theme(.dark)
///     .onDateSelected { date in
///         print("Selected date: \(date)")
///     }
/// ```
public struct MagicCalendar {
    // Static namespace for library information
    public static let version = "1.0.0"
    public static let name = "MagicCalendar"
}
