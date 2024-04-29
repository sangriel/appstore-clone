//
//  ViewModelType.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/19.
//

import Foundation


protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input : Input) -> Output
}
