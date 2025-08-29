import SwiftUI

// MARK: - Demo App
@main
struct MagicCalendarDemo: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Main Content View
struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Basic Calendar", destination: BasicCalendarExample())
                NavigationLink("Dark Theme", destination: DarkThemeCalendarExample())
                NavigationLink("Multi-Selection", destination: MultiSelectionCalendarExample())
                NavigationLink("Range Selection", destination: RangeSelectionCalendarExample())
                NavigationLink("Calendar with Events", destination: EventCalendarExample())
                NavigationLink("Custom Day Views", destination: CustomDayViewCalendarExample())
                NavigationLink("Monday First", destination: MondayFirstCalendarExample())
                NavigationLink("Limited Date Range", destination: LimitedDateRangeCalendarExample())
                NavigationLink("All Themes Showcase", destination: ThemeShowcaseView())
            }
            .navigationTitle("MagicCalendar Demo")
        }
    }
}

// MARK: - Theme Showcase
struct ThemeShowcaseView: View {
    @State private var selectedDate1: Date? = nil
    @State private var selectedDates1: Set<Date> = []
    @State private var events1: [Date: [CalendarEvent]] = [:]
    
    @State private var selectedDate2: Date? = nil
    @State private var selectedDates2: Set<Date> = []
    @State private var events2: [Date: [CalendarEvent]] = [:]
    
    @State private var selectedDate3: Date? = nil
    @State private var selectedDates3: Set<Date> = []
    @State private var events3: [Date: [CalendarEvent]] = [:]
    
    @State private var selectedDate4: Date? = nil
    @State private var selectedDates4: Set<Date> = []
    @State private var events4: [Date: [CalendarEvent]] = [:]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Group {
                    VStack {
                        Text("Default Theme")
                            .font(.headline)
                            .padding(.bottom, 5)
                        CalendarView(
                            selectedDate: $selectedDate1,
                            selectedDates: $selectedDates1,
                            events: $events1,
                            theme: .default
                        )
                    }
                    
                    VStack {
                        Text("Dark Theme")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        CalendarView(
                            selectedDate: $selectedDate2,
                            selectedDates: $selectedDates2,
                            events: $events2,
                            theme: .dark
                        )
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                }
                
                Group {
                    VStack {
                        Text("Minimal Theme")
                            .font(.headline)
                            .padding(.bottom, 5)
                        CalendarView(
                            selectedDate: $selectedDate3,
                            selectedDates: $selectedDates3,
                            events: $events3,
                            theme: .minimal
                        )
                    }
                    
                    VStack {
                        Text("Colorful Theme")
                            .font(.headline)
                            .padding(.bottom, 5)
                        CalendarView(
                            selectedDate: $selectedDate4,
                            selectedDates: $selectedDates4,
                            events: $events4,
                            theme: .colorful
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Theme Showcase")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
