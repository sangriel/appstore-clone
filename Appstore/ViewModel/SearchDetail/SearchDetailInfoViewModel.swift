//
//  SearchDetailInfoViewModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation

struct SearchDetailInfoViewModel {
    
    let userRatingCount : Int
    let averageRatingCount : Double
    let trackContentRating : String
    
    let sellerName : String
    let languageCodesISO2A : [String]
    
    init(userRatingCount: Int, averageRatingCount: Double, trackContentRating: String, sellerName: String, languageCodesISO2A: [String]) {
        self.userRatingCount = userRatingCount
        self.averageRatingCount = averageRatingCount
        self.trackContentRating = trackContentRating
        self.sellerName = sellerName
        self.languageCodesISO2A = languageCodesISO2A
    }
}
