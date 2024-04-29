//
//  SearchDetailNewFeatureView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class SearchDetailNewFeatureView : UIView {
    
    private let seperator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "새로운 기능"
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lb
    }()
    
    private let categoryLabel : UILabel = {
        let lb = UILabel()
        lb.text = "버전 기록"
        lb.textColor = .systemBlue
        lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return lb
    }()
    
    private let versionLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray4
        lb.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return lb
    }()
    
    private let dateLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray4
        lb.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return lb
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
        btn.backgroundColor = .clear
        btn.setTitle("더 보기", for: .normal)
        btn.setTitleColor( .systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        return btn
    }()
    
    /**
     초기 상태의 descriptionLabel의 높이
     */
    lazy private var shortHeightConstraint : NSLayoutConstraint = {
        return descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
    }()
    /**
     펼친 상태의 descriptionLabel의 높이
     */
    lazy private var longHeightConstraint : NSLayoutConstraint = {
        return descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 10000)
    }()
    
    private var viewModel : SearchDetailNewFeatureViewModel!
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bindView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        expandBtn.applyGradient(colours: [UIColor.white.withAlphaComponent(0),UIColor.white.withAlphaComponent(1)], locations: [0,0.2,1])
    }
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
    func setViewModel(viewModel : SearchDetailNewFeatureViewModel){
        self.viewModel = viewModel
        self.versionLabel.text = "버전 " + viewModel.version
        self.dateLabel.text = viewModel.currentVersionReleaseDate.pastDays()
        self.descriptionLabel.text = viewModel.releaseNotes
        
        // 초기 상태의 높이가 100이하라면 더 펼칠 내용이 없다는 것으로 더보기 버튼을 숨긴다
        if descriptionLabel.intrinsicContentSize.height <= 100 {
            expandBtn.isHidden = true
        }
        else {
            expandBtn.isHidden = false
        }
        
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
extension SearchDetailNewFeatureView {
    private func setLayout(){
        let topStack = UIStackView(arrangedSubviews: [titleLabel,categoryLabel])
        topStack.axis = .horizontal
        topStack.distribution = .equalSpacing
        
        let bottomStack = UIStackView(arrangedSubviews: [versionLabel,dateLabel])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        
        let fullStack = UIStackView(arrangedSubviews: [topStack,bottomStack])
        fullStack.translatesAutoresizingMaskIntoConstraints = false
        fullStack.axis = .vertical
        fullStack.spacing = 3
        
        self.addSubview(seperator)
        self.addSubview(fullStack)
        self.addSubview(descriptionLabel)
        self.addSubview(expandBtn)
        
        shortHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            seperator.topAnchor.constraint(equalTo: self.topAnchor),
            seperator.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
            seperator.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            fullStack.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            fullStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            fullStack.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            fullStack.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: fullStack.bottomAnchor,constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            
            expandBtn.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            expandBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15),
            expandBtn.widthAnchor.constraint(equalToConstant: 70),
            expandBtn.heightAnchor.constraint(equalToConstant: 30),
            
            self.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 40)
        ])
        
        
    }
}
