//
//  SearchDetailNewFeatureViewModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation

struct SearchDetailNewFeatureViewModel {
    
    let releaseNotes : String
    let currentVersionReleaseDate : String
    let version : String
    
    init(releaseNotes: String, currentVersionReleaseDate: String, version: String) {
        self.releaseNotes = releaseNotes
        self.currentVersionReleaseDate = currentVersionReleaseDate
        self.version = version
    }
}
