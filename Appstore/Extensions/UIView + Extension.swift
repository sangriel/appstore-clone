//
//  UIView + Extension.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation
import UIKit



extension UIView {
    
    func applyGradient(colours: [UIColor], locations: [NSNumber])  {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
