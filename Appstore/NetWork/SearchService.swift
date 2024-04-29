//
//  SearchService.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchServiceDelegate {
    func fetch(term : String) -> Observable<NetWorkResult<SearchResultListModel>>
}


class SearchService : SearchServiceDelegate {
    
    private let baseUrl : String = "https://itunes.apple.com/search"
    private let manager = NetWorkManager()
    
    
    
    func fetch(term : String) -> Observable<NetWorkResult<SearchResultListModel>> {
        let param : [String : Any] = ["term" : term,
                                      "country": "KR",
                                      "limit": 25,
                                      "media": "software"]
        return manager.execute(method: .GET, baseUrl: baseUrl, parameter: param)
    }
    
}
