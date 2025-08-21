//
//  Date+Extensions.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

extension Date {
    func formattedString(format: String = "HH_mm_ss_yyyy_MM_dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
