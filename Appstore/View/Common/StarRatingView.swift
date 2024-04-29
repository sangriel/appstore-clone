//
//  StarRatingView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit


class StarRatingView : UIView {
    
    
    private let starStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addArrangeSubviewToStack()
        setLayout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init(coder : NSCoder?) {
        fatalError("")
    }
    
    func setRating(rating : Double){
        for i in 0...4 {
            let star = starStack.arrangedSubviews[i] as! MaskStarView
            if Double(i) > rating {
                star.rating = 0
            }
            else if Double(i) <= rating &&  rating < Double(i + 1) {
                star.rating = CGFloat(rating - Double(i))
            }
            else {
                star.rating = 1
            }
        }
    }
    
    
}
extension StarRatingView {
    private func addArrangeSubviewToStack(){
        for _ in 0...4 {
            let star = MaskStarView()
            starStack.addArrangedSubview(star)
        }
        
    }
    private func setLayout(){
        self.addSubview(starStack)
        
        NSLayoutConstraint.activate([
            starStack.topAnchor.constraint(equalTo: self.topAnchor),
            starStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            starStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            starStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
