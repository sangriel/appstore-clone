//
//  NetWorkTest.swift
//  KakoBank_HWTests
//
//  Created by sangmin han on 2023/03/20.
//

import XCTest

@testable import KakoBank_HW

final class NetWorkTest: XCTestCase {

    
    let networkManager = NetWorkManager()
    let baseUrl : String = "https://itunes.apple.com/search"
    
    func testNetWorkManageGetRequestURL(){
        
        let (requestUrl,_ ) = networkManager.getRequestURL(method: .GET, baseUrl: baseUrl, parameter: ["a" : "b",
                                                                                                           "d" : 1,
                                                                                                           "e" : 1.0])
        
        guard let requestUrl = requestUrl else {
            XCTAssertThrowsError("no request URL")
            return
        }
        
        let url = requestUrl.url!
        
        
        XCTAssertEqual(valueOf(url: url, "a")!,"b")
        XCTAssertEqual(valueOf(url: url, "d")!,"1")
        XCTAssertEqual(valueOf(url: url, "e")!,"1.0")
        
    }
    
    private func valueOf(url : URL,_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: url.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
    
    
    

}
