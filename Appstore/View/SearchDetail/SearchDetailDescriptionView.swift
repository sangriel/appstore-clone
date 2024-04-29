//
//  SearchDetailDescriptionView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa



class SearchDetailDescriptionView : UIView {
   
    private let seperator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let descriptionLabel : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        return lb
    }()
    
    private let expandBtn : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.setTitle("더 보기", for: .normal)
        btn.setTitleColor( .systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return btn
    }()
    
    
    private let companyLabel : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        return lb
    }()
    
    private let arrowBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = .systemGray4
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    
    /**
     초기 상태의 descriptionLabel의 높이
     */
    lazy private var shortHeightConstraint : NSLayoutConstraint = {
        return descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
    }()
    /**
     펼친 상태의 descriptionLabel의 높이
     */
    lazy private var longHeightConstraint : NSLayoutConstraint = {
        return descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 10000)
    }()
    
    
    private var viewModel : SearchDetailDescriptionViewModel!
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bindView()
        
    
    }
    
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        expandBtn.applyGradient(colours: [UIColor.white.withAlphaComponent(0),UIColor.white.withAlphaComponent(1)], locations: [0,0.2,1])
    }
    
    func setViewModel(viewModel : SearchDetailDescriptionViewModel){
        self.viewModel = viewModel
        self.descriptionLabel.text = viewModel.description
        self.companyLabel.attributedText = viewModel.sellerName
    }
    
    private func bindView(){
        expandBtn.rx.tap
            .subscribe(onNext : { [unowned self] in
                self.shortHeightConstraint.isActive = false
                self.longHeightConstraint.isActive = true
                expandBtn.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    
}
extension SearchDetailDescriptionView {
    private func setLayout(){
        self.addSubview(seperator)
        self.addSubview(descriptionLabel)
        self.addSubview(expandBtn)
        
        let stack = UIStackView(arrangedSubviews: [companyLabel,arrowBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        self.addSubview(stack)
        
        
        shortHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            seperator.topAnchor.constraint(equalTo: self.topAnchor),
            seperator.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
            seperator.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            
            expandBtn.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            expandBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            expandBtn.widthAnchor.constraint(equalToConstant: 60),
            expandBtn.heightAnchor.constraint(equalToConstant: 30),
            
            stack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 20),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            stack.heightAnchor.constraint(equalToConstant: 40),
            
            self.bottomAnchor.constraint(equalTo: stack.bottomAnchor,constant: 20)
        
        ])
        
    }
}
