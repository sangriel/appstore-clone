//
//  SearchDetailDescriptionViewModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation
import UIKit

struct SearchDetailDescriptionViewModel {
    
    let description : String
    let sellerName : NSAttributedString
    
    init(description: String, sellerName: String) {
        self.description = description
       
        let attr = NSMutableAttributedString(string: "\(sellerName)\n개발자",
                                             attributes: [.font : UIFont.systemFont(ofSize: 15, weight: .regular),
                                                          .foregroundColor : UIColor.systemBlue])
        
        let range = NSString(string: "\(sellerName)\n개발자").range(of: "개발자")
        attr.addAttributes([.font : UIFont.systemFont(ofSize: 13, weight: .regular),
                            .foregroundColor : UIColor.systemGray4], range: range)
        self.sellerName = attr
        
        
        
    }
}
