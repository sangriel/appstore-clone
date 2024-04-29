//
//  SearchDetailInfoBox.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit

/**
 SearchDetailViewController에서 평가, 연령, 개발자, 언어 등을 보여주는 화면
 내용물이 UIImageView, UILabel, RatingView등 임의로 될 수 있으므로
 UIView로 위치만 잡아준다
 */
class SearchDetailInfoBox : UIView {
    
    
    private let topView : UIView!
    
    private let middleView : UIView!
    
    private let bottomView : UIView!
    
    private let seperator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    init(frame: CGRect, topView : UIView, middleView : UIView, bottomView : UIView, hideSeperator : Bool = false) {
        self.topView = topView
        self.middleView = middleView
        self.bottomView = bottomView
        super.init(frame: frame)
        self.seperator.isHidden = hideSeperator
        setLayout()
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
}
extension SearchDetailInfoBox {
    private func setLayout(){
        
        self.addSubview(topView)
        self.addSubview(middleView)
        self.addSubview(bottomView)
        self.addSubview(seperator)
        topView.translatesAutoresizingMaskIntoConstraints = false
        middleView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topView.widthAnchor.constraint(equalTo: self.widthAnchor),
            topView.heightAnchor.constraint(equalToConstant: 14),
            
            middleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            middleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            middleView.widthAnchor.constraint(equalTo: self.widthAnchor),
            middleView.heightAnchor.constraint(equalToConstant: 20),
            
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 10),
            bottomView.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -20),
            
            seperator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            seperator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 50),
            seperator.widthAnchor.constraint(equalToConstant: 1),
            
            self.widthAnchor.constraint(equalToConstant: 120),
            self.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    
}
