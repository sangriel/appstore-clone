//
//  StringExtensionTest.swift
//  KakoBank_HWTests
//
//  Created by sangmin han on 2023/03/21.
//

import XCTest

@testable import KakoBank_HW


final class StringExtensionTest: XCTestCase {

    
    func testStringExtensionPastDays(){
        
        let source = "2023-03-07T01:15:00Z"
        let after15Min = "2023-03-07T01:30:00Z"
        let after1H = "2023-03-07T02:15:00Z"
        let after2D = "2023-03-09T01:15:00Z"
        let after2D15M = "2023-03-09T01:30:00Z"
        let after1Week = "2023-03-14T01:15:00Z"
        let after2Week = "2023-03-21T01:15:00Z"
        let arter1Month = "2023-04-07T01:15:00Z"
        
        
        XCTAssertEqual(source.pastDays(from: after15Min), "15분 전")
        XCTAssertEqual(source.pastDays(from: after1H), "1시간 전")
        XCTAssertEqual(source.pastDays(from: after2D), "2일 전")
        XCTAssertEqual(source.pastDays(from: after2D15M), "2일 전")
        XCTAssertEqual(source.pastDays(from: after1Week), "1주 전")
        XCTAssertEqual(source.pastDays(from: after2Week), "2주 전")
        XCTAssertEqual(source.pastDays(from: arter1Month), "1개월 전")
        
        
    }
  
    

}
