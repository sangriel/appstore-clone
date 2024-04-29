//
//  String + Extension.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation

extension String {
    /**
     두 날짜 사이의 간격을 구하는 함수 
     */
    func pastDays(from : String? = nil) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        guard let date = dateformatter.date(from: self) else {
            print("time parse failed")
            return ""
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale.init(identifier: "ko-US")
        if let from = from, let fromDate = dateformatter.date(from: from) {
           return formatter.localizedString(for: date, relativeTo: fromDate)
        }
        else {
            return formatter.localizedString(for: date, relativeTo: Date())
        }
    }
}

