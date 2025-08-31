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
    @State private var calculatedHeight: CGFloat = 0   // 👈 independent state
    
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
    
    public init(
        selectedDate: Binding<Date>,
        isExpanded:Bool,
        events: [Event],
        headerStyle: HeaderStyle = .titleInCenter,
        prevIcon: CalendarIcon = .system(name: "chevron.left"),
        nextIcon: CalendarIcon = .system(name: "chevron.right"),
        headerAccentColor: Color = .black,
        activeTextColor: Color = .black,
        inactiveTextColor: Color = .gray,
        daysBarColor: Color = .black,
        dateBoxStyle: DateBoxStyle = .filledCircle(color: .gray.opacity(0.3)),
        selectedDateBoxStyle: DateBoxStyle = .filledCircle(color: .blue),
        selectedDayTextColor: Color = .white,
        swipeEnabled: Bool = true,
        bgStyle: some ShapeStyle = Color.clear,
        collapseButtonTint: Color = .black,
        headerFontStyle: HeaderFontStyle = HeaderFontStyle(font: .system(size: 20), fontWeight: .bold),
        topSpacing: CGFloat = 10,
        gridPadding: CGFloat = 4,
        showCollapsingButton: Bool = true,
        daysNameFormat:String = "EEEEE"
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
    }
    
    public var body: some View {
        let startPage = 500
        let currentMonth = Calendar.current.date(byAdding: .month, value: currentPage - startPage, to: Date()) ?? Date()

        VStack(spacing:2) {
            CalendarHeader(
                currentMonth: currentMonth,
                headerStyle: headerStyle,
                prevIcon: prevIcon,
                nextIcon: nextIcon,
                onPrevious: {
                    currentPage -= 1
                    updateSelectedDate(byMonths: -1)
                    recalcHeight(for: currentPage, startPage: startPage)
                },
                onNext: {
                    currentPage += 1
                    updateSelectedDate(byMonths: 1)
                    recalcHeight(for: currentPage, startPage: startPage)
                },
                accentColor: headerAccentColor,
                headerFontStyle: headerFontStyle
            )

            VStack(spacing:2) {
                if swipeEnabled {
                    TabView(selection: $currentPage) {
                        ForEach((0..<1000), id: \.self) { page in
                            let monthDate = Calendar.current.date(byAdding: .month, value: page - startPage, to: Date()) ?? Date()
                            CalendarGridView(
                                monthDate: monthDate,
                                selectedDate: $selectedDate,
                                events: events,
                                selectedDayTextColor: selectedDayTextColor,
                                dateBoxStyle: dateBoxStyle,
                                selectedDateBoxStyle: selectedDateBoxStyle,
                                activeTextColor: activeTextColor,
                                inactiveTextColor: inactiveTextColor,
                                isExpanded: isExpanded,
                                selectedRowIndex: 0, // row index recalculated later
                                verticalSpacing: 5,
                                topSpacing: topSpacing,
                                daysBarColor: daysBarColor,
                                daysNameFormat: daysNameFormat
                            )
                            .tag(page)
                        }
                    }
                    .onChange(of: currentPage) { newPage in
                        if let newDate = Calendar.current.date(byAdding: .month, value: newPage - startPage, to: Date()) {
                            selectedDate = newDate
                        }
                        // 👇 recalc after page is set, with animation
                        withAnimation(.easeInOut) {
                            recalcHeight(for: newPage, startPage: startPage)
                        }
                    }
                    .frame(height: calculatedHeight) // 👈 use state-driven height
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
            recalcHeight(for: currentPage, startPage: startPage)
        }
    }
    
    /// ✅ Centralized logic to recalc height only when page change is complete
    private func recalcHeight(for page: Int, startPage: Int) {
        let monthDate = Calendar.current.date(byAdding: .month, value: page - startPage, to: Date()) ?? Date()
        let weeks = getWeeksInMonth(monthDate)
        let totalRows = (weeks.count - 1)
        let visibleRows = isExpanded ? totalRows : 1
        let rowHeight = UIScreen.main.bounds.width / 7
        calculatedHeight = isExpanded
            ? (rowHeight + 10) * CGFloat(visibleRows) - 5 + topSpacing
            : (rowHeight + 30 + topSpacing)
    }
    
    private func updateSelectedDate(byMonths months: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: months, to: selectedDate) {
            selectedDate = newDate
        }
    }
}
