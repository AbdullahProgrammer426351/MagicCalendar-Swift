//
//  SwiftUIView.swift
//  MagicCalendar
//
//  Created by APPLE on 28/02/2026.
//

import SwiftUI

extension Date {
    func strippedTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}
