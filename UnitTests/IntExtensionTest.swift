//
//  IntExtensionTest.swift
//  KakoBank_HWTests
//
//  Created by sangmin han on 2023/03/20.
//

import XCTest

@testable import KakoBank_HW


final class IntExtensionTest: XCTestCase {

    func testIntExtensionAbstractedNumberString(){
        
        
        let a : Int = 10000
        let b : Int = 11000
        let c : Int = 1000
        let d : Int = 1100
        let e : Int = 999
        let f : Int = 122000
        
        XCTAssertEqual(a.abstractedNumberString, "1만")
        XCTAssertEqual(b.abstractedNumberString, "1.1만")
        XCTAssertEqual(c.abstractedNumberString, "1천")
        XCTAssertEqual(d.abstractedNumberString, "1.1천")
        XCTAssertEqual(e.abstractedNumberString, "999")
        XCTAssertEqual(f.abstractedNumberString, "12.2만")
        
    }
    

}
