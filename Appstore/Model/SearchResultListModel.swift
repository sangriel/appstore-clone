//
//  SearchResultListModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation

struct SearchResultListModel : Codable {
    let resultCount : Int?
    let results : [SearchResultModel]

    enum CodingKeys: String, CodingKey {

        case resultCount = "resultCount"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try values.decode(Int.self, forKey: .resultCount)
        results = try values.decode([SearchResultModel].self, forKey: .results)
    }
    

}
