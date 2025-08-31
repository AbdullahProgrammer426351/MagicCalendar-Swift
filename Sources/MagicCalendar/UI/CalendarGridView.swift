//
//  CalendarGridView.swift
//  MagicCalendar
//
//  Created by APPLE on 31/08/2025.
//

import SwiftUI

struct CalendarGridView: View {
    let monthDate: Date   // 👈 NEW: month to display
    @Binding var selectedDate: Date
    let events: [Event]
    let selectedDayTextColor: Color
    let dateBoxStyle: DateBoxStyle
    let selectedDateBoxStyle: DateBoxStyle
    let activeTextColor: Color
    let inactiveTextColor: Color
    let isExpanded: Bool
    let selectedRowIndex: Int
    let verticalSpacing: CGFloat
    let topSpacing: CGFloat
    let daysBarColor: Color
    let daysNameFormat:String

    private var weeks: [[Date]] {
        getWeeksInMonth(monthDate) // 👈 build weeks for this month
    }

    private var displayWeeks: [[Date]] {
        if isExpanded {
            return weeks
        } else {
            let index = max(0, selectedRowIndex)
            return [weeks[index]]
        }
    }

    var body: some View {
        ScrollView {
            GeometryReader { g in
                LazyVStack(spacing: verticalSpacing) {
                    // Day headers
                    HStack(spacing:0) {
                        ForEach(getLocalizedWeekDays(format: daysNameFormat), id: \.self) { day in
                            Text(String(day.prefix(3)))
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                                .foregroundColor(daysBarColor)
                        }
                    }
                    .padding(.top, topSpacing)

                    // Weeks
                    ForEach(displayWeeks, id: \.self) { week in
                        HStack(spacing: 0) {
                            ForEach(week, id: \.self) { date in
                                CalendarDayView(
                                    date: date,
                                    isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                    events: events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) },
                                    isInCurrentMonth: Calendar.current.isDate(date, equalTo: monthDate, toGranularity: .month), // 👈 compare with monthDate now
                                    selectedDayTextColor: selectedDayTextColor,
                                    dateBoxStyle: dateBoxStyle,
                                    selectedDateBoxStyle: selectedDateBoxStyle,
                                    activeTextColor: activeTextColor,
                                    inactiveTextColor: inactiveTextColor,
                                    width: g.size.width
                                ) {
                                    selectedDate = date
                                }
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getLocalizedWeekDays(format: String) -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        
        var symbols: [String] = []
        let calendar = Calendar.current
        
        // Start from Sunday (1) through Saturday (7) in the current calendar
        for weekday in calendar.weekdaySymbols.indices {
            let weekdayDate = calendar.date(from: DateComponents(weekday: weekday + 1))!
            symbols.append(formatter.string(from: weekdayDate))
        }
        
        return symbols
    }

    
    

}

func getWeeksInMonth(_ selectedDate: Date) -> [[Date]] {
    let calendar = Calendar.current
    
    guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
          let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
    else { return [] }
    
    var startDate = monthFirstWeek.start
    let endDate = monthInterval.end  // 👈 stop strictly at month end
    
    var weeks: [[Date]] = []
    var currentWeek: [Date] = []
    
    while startDate < endDate {
        currentWeek.append(startDate)
        
        if currentWeek.count == 7 {
            weeks.append(currentWeek)
            currentWeek.removeAll()
        }
        
        startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
    }
    
    // In case month doesn’t end exactly at week boundary, pad last week
    if !currentWeek.isEmpty {
        while currentWeek.count < 7 {
            currentWeek.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        weeks.append(currentWeek)
    }
    
    return weeks
}
