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
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Group {
                    VStack {
                        Text("Default Theme")
                            .font(.headline)
                            .padding(.bottom, 5)
                        CalendarView()
                            .theme(.default)
                    }
                    
                    VStack {
                        Text("Dark Theme")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        CalendarView()
                            .theme(.dark)
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
                        CalendarView()
                            .theme(.minimal)
                    }
                    
                    VStack {
                        Text("Colorful Theme")
                            .font(.headline)
                            .padding(.bottom, 5)
                        CalendarView()
                            .theme(.colorful)
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
