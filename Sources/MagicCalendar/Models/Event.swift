//
//  Event.swift
//  MagicCalendar
//
//  Created by APPLE on 31/08/2025.
//


import SwiftUI

public struct Event {
    public let date: Date
    public let eventColor: Color
    public let icon: EventIcon?
    public let indicator: EventIndicator?

    public init(date: Date,
                eventColor: Color,
                icon: EventIcon? = nil,
                indicator: EventIndicator? = nil) {
        self.date = date
        self.eventColor = eventColor
        self.icon = icon
        self.indicator = indicator
    }
}

