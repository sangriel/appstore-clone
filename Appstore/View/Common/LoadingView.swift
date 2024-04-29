//
//  LoadingView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit


class LoadingView : UIView {
    
    
    private let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = UIActivityIndicatorView.Style.large
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func startAnimate(){
        self.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimate(){
        self.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
}
extension LoadingView {
    private func setLayout(){
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
