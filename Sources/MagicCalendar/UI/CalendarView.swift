//
//  CalendarView.swift
//  MagicCalendar
//
//  Created by APPLE on 31/08/2025.
//

import SwiftUI

public struct CalendarView: View {
    @State private var currentPage: Int = 500
    @Binding private var selectedDate: Date
    @State var isExpanded: Bool = true
    @State private var calculatedHeight: CGFloat = 0
    @State private var gridWidth: CGFloat = 0
    
    @State private var selectedRowIndex: Int = 0

    
    let events: [Event]
    let headerStyle: HeaderStyle
    let prevIcon: CalendarIcon
    let nextIcon: CalendarIcon
    let headerAccentColor: Color
    let activeTextColor: Color
    let inactiveTextColor: Color
    let daysBarColor: Color
    let dateBoxStyle: DateBoxStyle
    let selectedDateBoxStyle: DateBoxStyle
    let selectedDayTextColor: Color
    let swipeEnabled: Bool
    let bgStyle: AnyShapeStyle
    let collapseButtonTint: Color
    let headerFontStyle: HeaderFontStyle
    let topSpacing: CGFloat
    let gridPadding: CGFloat
    let showCollapsingButton: Bool
    let daysNameFormat:String
    private let respectSelection:Bool
    private let onDateTap: (Date) -> Void
    private let startPage = 500
    private let maxPage = 999
    private let gridVerticalSpacing: CGFloat = 5
    private let pageWindowSize: Int = 7
    @State private var pageWindowStart: Int = 0
    
    public init(
        selectedDate: Binding<Date>,
        isExpanded:Bool,
        events: [Event],
        headerStyle: HeaderStyle = .titleInCenter,
        prevIcon: CalendarIcon = .system(name: "chevron.backward"),
        nextIcon: CalendarIcon = .system(name: "chevron.forward"),
        headerAccentColor: Color = .primary,
        activeTextColor: Color = .primary,
        inactiveTextColor: Color = .gray,
        daysBarColor: Color = .primary,
        dateBoxStyle: DateBoxStyle = .filledCircle(color: .gray.opacity(0.3)),
        selectedDateBoxStyle: DateBoxStyle = .filledCircle(color: .blue),
        selectedDayTextColor: Color = .white,
        swipeEnabled: Bool = true,
        bgStyle: some ShapeStyle = Color.clear,
        collapseButtonTint: Color = .primary,
        headerFontStyle: HeaderFontStyle = HeaderFontStyle(font: .system(size: 20), fontWeight: .bold),
        topSpacing: CGFloat = 10,
        gridPadding: CGFloat = 4,
        showCollapsingButton: Bool = true,
        daysNameFormat:String = "EEEEE",
        respectSelection:Bool = true,
        onDateTap: @escaping (Date) -> Void = { _ in }
    ) {
        _selectedDate = selectedDate
        self.isExpanded = isExpanded
        self.events = events
        self.headerStyle = headerStyle
        self.prevIcon = prevIcon
        self.nextIcon = nextIcon
        self.headerAccentColor = headerAccentColor
        self.activeTextColor = activeTextColor
        self.inactiveTextColor = inactiveTextColor
        self.daysBarColor = daysBarColor
        self.dateBoxStyle = dateBoxStyle
        self.selectedDateBoxStyle = selectedDateBoxStyle
        self.selectedDayTextColor = selectedDayTextColor
        self.swipeEnabled = swipeEnabled
        self.bgStyle = AnyShapeStyle(bgStyle)
        self.collapseButtonTint = collapseButtonTint
        self.headerFontStyle = headerFontStyle
        self.topSpacing = topSpacing
        self.gridPadding = gridPadding
        self.showCollapsingButton = showCollapsingButton
        self.daysNameFormat = daysNameFormat
        self.respectSelection = respectSelection
        self.onDateTap = onDateTap
    }
    
    public var body: some View {
        let currentMonth = Calendar.current.date(byAdding: .month, value: currentPage - startPage, to: Date()) ?? Date()
        let allEventsByDay = Dictionary(grouping: events, by: { $0.date.strippedTime() })

        VStack(spacing:2) {
            CalendarHeader(
                currentMonth: currentMonth,
                headerStyle: headerStyle,
                prevIcon: prevIcon,
                nextIcon: nextIcon,
                onPrevious: {
                    let newPage = max(0, currentPage - 1)
                    guard newPage != currentPage else { return }
                    currentPage = newPage
                    updateSelectedDate(byMonths: -1)
                    withAnimation(.easeInOut){
                        recalcHeight(for: currentPage, startPage: startPage)
                    }
                },
                onNext: {
                    let newPage = min(maxPage, currentPage + 1)
                    guard newPage != currentPage else { return }
                    currentPage = newPage
                    updateSelectedDate(byMonths: 1)
                    withAnimation(.easeInOut){
                        recalcHeight(for: currentPage, startPage: startPage)
                    }
                },
                accentColor: headerAccentColor,
                headerFontStyle: headerFontStyle
            )
            .padding(.horizontal, 10)

            VStack(spacing: 2) {
                if swipeEnabled {
                    TabView(selection: $currentPage) {
                        ForEach(visiblePages, id: \.self) { page in
                            let monthDate = Calendar.current.date(
                                byAdding: .month,
                                value: page - startPage,
                                to: Date()
                            ) ?? Date()
                            
                            CalendarGridView(
                                monthDate: monthDate,
                                selectedDate: $selectedDate,
                                eventsByDay: monthEventsByDay(for: monthDate, from: allEventsByDay),
                                selectedDayTextColor: selectedDayTextColor,
                                dateBoxStyle: dateBoxStyle,
                                selectedDateBoxStyle: selectedDateBoxStyle,
                                activeTextColor: activeTextColor,
                                inactiveTextColor: inactiveTextColor,
                                isExpanded: isExpanded,
                                selectedRowIndex: selectedRowIndex,
                                verticalSpacing: gridVerticalSpacing,
                                topSpacing: topSpacing,
                                daysBarColor: daysBarColor,
                                daysNameFormat: daysNameFormat,
                                respectSelection: respectSelection,
                                onDateTap: onDateTap
                            )
                            .tag(page)
                        }
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    updateGridWidth(proxy.size.width)
                                }
                                .onChange(of: proxy.size.width) { newWidth in
                                    updateGridWidth(newWidth)
                                }
                        }
                    )
                    .onChange(of: currentPage) { newPage in
                        adjustPageWindowIfNeeded(for: newPage)
                        if let newDate = Calendar.current.date(
                            byAdding: .month,
                            value: newPage - startPage,
                            to: Date()
                        ) {
                            selectedDate = newDate
                        }
                        recalcHeight(for: newPage, startPage: startPage)
                    }
                    .frame(height: calculatedHeight)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .background(bgStyle)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                } else {
                    // ✅ Show only current page's grid without TabView
                    let monthDate = Calendar.current.date(
                        byAdding: .month,
                        value: currentPage - startPage,
                        to: Date()
                    ) ?? Date()
                    
                    CalendarGridView(
                        monthDate: monthDate,
                        selectedDate: $selectedDate,
                        eventsByDay: monthEventsByDay(for: monthDate, from: allEventsByDay),
                        selectedDayTextColor: selectedDayTextColor,
                        dateBoxStyle: dateBoxStyle,
                        selectedDateBoxStyle: selectedDateBoxStyle,
                        activeTextColor: activeTextColor,
                        inactiveTextColor: inactiveTextColor,
                        isExpanded: isExpanded,
                        selectedRowIndex: selectedRowIndex,
                        verticalSpacing: gridVerticalSpacing,
                        topSpacing: topSpacing,
                        daysBarColor: daysBarColor,
                        daysNameFormat: daysNameFormat,
                        respectSelection: respectSelection,
                        onDateTap: onDateTap
                    )
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    updateGridWidth(proxy.size.width)
                                }
                                .onChange(of: proxy.size.width) { newWidth in
                                    updateGridWidth(newWidth)
                                }
                        }
                    )
                    .frame(height: calculatedHeight)
                    .background(bgStyle)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }

                if showCollapsingButton {
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                            recalcHeight(for: currentPage, startPage: startPage)
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .fontWeight(.bold)
                            .foregroundColor(collapseButtonTint)
                    }
                    .padding(8)
                }
            }

        }
        .onAppear {
            currentPage = page(for: selectedDate)
            pageWindowStart = initialPageWindowStart(for: currentPage)
            recalcHeight(for: currentPage, startPage: startPage)
        }
        .onChange(of: selectedDate) { newDate in
            let newPage = page(for: newDate)
            if newPage != currentPage {
                currentPage = newPage
            }
        }
    }
    
    /// ✅ Centralized logic to recalc height only when page change is complete
    private func recalcHeight(for page: Int, startPage: Int) {
        let monthDate = Calendar.current.date(byAdding: .month, value: page - startPage, to: Date()) ?? Date()
        let weeks = getWeeksInMonth(monthDate)

        // ✅ find which row contains the selectedDate
        let rowIndex = weeks.firstIndex { week in
            week.contains { date in
                Calendar.current.isDate(date, inSameDayAs: selectedDate)
            }
        } ?? 0
        
        selectedRowIndex = rowIndex   // 👈 update state
        
        let totalRows = max(weeks.count, 1)
        let visibleRows = isExpanded ? totalRows : 1
        let availableWidth = gridWidth > 0 ? gridWidth : UIScreen.main.bounds.width
        let rowHeight = availableWidth / 7
        let dayHeaderHeight = ceil(UIFont.preferredFont(forTextStyle: .body).lineHeight)
        let spacingCount = CGFloat(visibleRows) // header->row1 + row-to-row gaps

        calculatedHeight =
            topSpacing +
            dayHeaderHeight +
            (CGFloat(visibleRows) * rowHeight) +
            (spacingCount * gridVerticalSpacing)
    }

    
    private func updateSelectedDate(byMonths months: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: months, to: selectedDate) {
            selectedDate = newDate
        }
    }

    private func page(for date: Date) -> Int {
        let calendar = Calendar.current
        let todayMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date().strippedTime())) ?? Date().strippedTime()
        let targetMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date.strippedTime())) ?? date.strippedTime()
        let monthDiff = calendar.dateComponents([.month], from: todayMonth, to: targetMonth).month ?? 0
        let rawPage = startPage + monthDiff
        return min(max(rawPage, 0), maxPage)
    }

    private func updateGridWidth(_ width: CGFloat) {
        guard width > 0, abs(width - gridWidth) > 0.5 else { return }
        gridWidth = width
        recalcHeight(for: currentPage, startPage: startPage)
    }

    private var visiblePages: [Int] {
        let end = min(maxPage, pageWindowStart + pageWindowSize - 1)
        return Array(pageWindowStart...end)
    }

    private func initialPageWindowStart(for page: Int) -> Int {
        let half = pageWindowSize / 2
        let candidate = page - half
        let maxWindowStart = max(0, maxPage - pageWindowSize + 1)
        return min(max(candidate, 0), maxWindowStart)
    }

    private func adjustPageWindowIfNeeded(for page: Int) {
        let maxWindowStart = max(0, maxPage - pageWindowSize + 1)
        let end = min(maxPage, pageWindowStart + pageWindowSize - 1)

        if page <= pageWindowStart {
            pageWindowStart = max(0, page - 1)
        } else if page >= end {
            pageWindowStart = min(maxWindowStart, page - (pageWindowSize - 2))
        }
    }

    private func monthEventsByDay(for monthDate: Date, from allEventsByDay: [Date: [Event]]) -> [Date: [Event]] {
        let visibleDates = getWeeksInMonth(monthDate).flatMap { $0 }.map { $0.strippedTime() }
        var result: [Date: [Event]] = [:]
        result.reserveCapacity(visibleDates.count)
        
        for date in visibleDates {
            if let dayEvents = allEventsByDay[date], !dayEvents.isEmpty {
                result[date] = dayEvents
            }
        }
        
        return result
    }
}
