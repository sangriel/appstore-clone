//
//  Enums.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation


enum CustomError : Error {
    case error(String)
    case selfDeallocated
}

/**
 Network 결과에서 error가 발생할 경우 구독이 끊기는 것을 방지하기 위해 사용
 */
enum NetWorkResult<T : Codable> {
    case success(T)
    case error(Error)
}
