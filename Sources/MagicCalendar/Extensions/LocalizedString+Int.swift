//
//  File.swift
//  MagicCalendar
//
//  Created by APPLE on 04/10/2025.
//

import Foundation

extension Int {
    func localizedString(locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
