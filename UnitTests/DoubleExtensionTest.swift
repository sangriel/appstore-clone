//
//  DoubleExtensionTest.swift
//  KakoBank_HWTests
//
//  Created by sangmin han on 2023/03/21.
//

import XCTest

@testable import KakoBank_HW


final class DoubleExtensionTest: XCTestCase {

    func testDoubleExtensionFormattedString(){
        
        
        let a : Double = 3.123456
        
        XCTAssertEqual(a.formattedString(maxFractionDigits: 1), "3.1")
        XCTAssertEqual(a.formattedString(maxFractionDigits: 2), "3.12")
        XCTAssertEqual(a.formattedString(maxFractionDigits: 3), "3.123")
        XCTAssertEqual(a.formattedString(maxFractionDigits: 4), "3.1234")
        
        let b : Double = 32.123456
        
        XCTAssertEqual(b.formattedString(maxFractionDigits: 1), "32.1")
        XCTAssertEqual(b.formattedString(maxFractionDigits: 2), "32.12")
        XCTAssertEqual(b.formattedString(maxFractionDigits: 3), "32.123")
        XCTAssertEqual(b.formattedString(maxFractionDigits: 4), "32.1234")
        
        let c : Double = 3.0
        XCTAssertEqual(c.formattedString(maxFractionDigits: 1), "3.0")
        
        let d : Double = 3
        XCTAssertEqual(d.formattedString(maxFractionDigits: 1), "3.0")
        
        let e : Double = 3.001
        XCTAssertEqual(e.formattedString(maxFractionDigits: 3), "3.001")
        
        let f : Double = 0.1123
        XCTAssertEqual(f.formattedString(maxFractionDigits: 3), "0.112")
        
    }

}
