//
//  SearchDetailTitleViewModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation


struct SearchDetailTitleViewModel {
    
    let appIconUrl : String
    let title : String
    let subTitle : String
    
    init(appIconUrl: String, title: String, subTitle: String) {
        self.appIconUrl = appIconUrl
        self.title = title
        self.subTitle = subTitle
    }
}
