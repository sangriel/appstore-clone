//
//  Int + Extension.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation


extension Int {
    
    /**
     천이상의 숫자를 x.x천, x.x만으로 변형
     */
    var abstractedNumberString : String {
        get {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 1
            var appendix : String = ""
            if self >= 10000 {
                formatter.multiplier = 0.0001
                appendix = "만"
            }
            else if self < 10000 && self >= 1000 {
                formatter.multiplier = 0.001
                appendix = "천"
            }
            else {
                formatter.multiplier = 1
            }
            if let result = formatter.string(from: NSNumber(value: Double(self))) {
                return result + appendix
            }
            return ""
        }
    }
    
}
