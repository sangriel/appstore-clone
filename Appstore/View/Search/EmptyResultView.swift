//
//  EmptyResultView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit


class EmptyResultView : UIView {
    
    private let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setLayout()
        
    }
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
    func setSearchWord(searchWord : String){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.alignment = .center
        let attr = NSMutableAttributedString(string: "결과 없음\n'\(searchWord)'",
                                             attributes: [.foregroundColor : UIColor.black,
                                                          .font : UIFont.systemFont(ofSize: 20, weight: .bold),
                                                          .paragraphStyle : style ])
        
        let range = NSString(string: "결과 없음\n'\(searchWord)'").range(of: "'\(searchWord)'")
        attr.addAttributes([.foregroundColor : UIColor.darkGray,
                            .font : UIFont.systemFont(ofSize: 15, weight: .regular)]
                           ,range: range)
        label.attributedText = attr
        
    }
}
extension EmptyResultView {
    private func setLayout(){
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }
}
