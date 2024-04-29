//
//  Double + Extension.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation


extension Double {
    
    /**
     소수점으로 이루어진 숫자를 maxFracitionDigits의 소수점까지만 짤라서 String으로 변환해주는 함수
     */
    func formattedString(maxFractionDigits : Int) -> String {
        let parsed = "\(self)".components(separatedBy: ".")
        return parsed[0] + "." + String(parsed[1].prefix(maxFractionDigits))
    }
    
}
