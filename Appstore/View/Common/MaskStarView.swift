//
//  MaskStarView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit


class MaskStarView : UIView {
    
    /**
     채워져 있는 별의 이미지
     */
    lazy private var starImage : UIImageView = {
        let star = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image:star)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.mask = maskingView
        return imageView
    }()
    
    private let maskLayer : CALayer = {
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.white.cgColor
        return maskLayer
    }()
    
    /**
     채워져 있지 않은 별의 이미지
     배경 화면을 투명하게 만든후  maskLayer로 rating 만큼 색깔을 채워 넣는다
     그리고 이 뷰를 startImage에 마스킹 했을때 alpha != 0인 부분(maskLayer의 부분)은 투명하게 처리되고,
     남은 부분은 채워져 있지 않은 별의 이미지가 그대로 보여지게 된다
     */
    lazy private var maskingView : UIImageView = {
        let star = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: star)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .gray
        imageView.layer.addSublayer(maskLayer)
        return imageView
    }()
    
    /**
     점수를 할당 받은 이후에 해당 뷰의 크기를 알아야지 maskLayer의 프레임을 정확히 잡을 수 있음
     rating -> 0 ~ 1 사이
     */
    var rating : CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        maskingView.frame = starImage.bounds
        maskLayer.frame = maskingView.bounds
        maskLayer.frame.size.width = self.frame.width * rating
    }
    
    
    
    
    
    
}
extension MaskStarView {
    private func setLayout(){
        self.addSubview(starImage)
        
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starImage.widthAnchor.constraint(equalTo: self.widthAnchor),
            starImage.heightAnchor.constraint(equalTo: self.heightAnchor)
            
        ])
    }
}
