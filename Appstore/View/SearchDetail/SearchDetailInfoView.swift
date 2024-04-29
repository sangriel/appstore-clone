//
//  SearchDetailInfoView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit


class SearchDetailInfoView : UIView {
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 0
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return stack
    }()
    
    
   
    lazy private var ratingTopView : UILabel = self.maketopView("")
    lazy private var ratingMiddleView : UILabel = self.makemiddleLabel()
    private let ratingBottomView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [StarRatingView()])
        stack.axis = .horizontal
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return stack
    }()
    lazy private var ratingBox = SearchDetailInfoBox(frame: .zero, topView: ratingTopView, middleView: ratingMiddleView, bottomView: ratingBottomView)
    
    lazy private var ageTopView : UILabel = self.maketopView("연령")
    lazy private var ageMiddleView : UILabel = self.makemiddleLabel()
    lazy private var ageBottomView : UILabel = self.makebottomLabel("세")
    lazy private var ageBox = SearchDetailInfoBox(frame: .zero, topView: ageTopView, middleView: ageMiddleView, bottomView: ageBottomView)
    
    
    lazy private var developerTopView : UILabel = self.maketopView("개발자")
    private let developerMiddleView : UIImageView = {
        let image =  UIImage(systemName: "person.crop.square")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    lazy private var developerBottomView : UILabel = self.makebottomLabel("")
    lazy private var developerBox = SearchDetailInfoBox(frame: .zero, topView: developerTopView, middleView: developerMiddleView, bottomView: developerBottomView)
    
    
    lazy private var langTopView : UILabel = self.maketopView("언어")
    lazy private var langMiddleView : UILabel = self.makemiddleLabel()
    lazy private var langBottomView : UILabel = self.makebottomLabel("")
    lazy private var langBox = SearchDetailInfoBox(frame: .zero, topView: langTopView, middleView: langMiddleView, bottomView: langBottomView,hideSeperator: true)
    
    private let seperator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private var viewModel : SearchDetailInfoViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(viewModel : SearchDetailInfoViewModel){
        self.viewModel = viewModel
        ratingTopView.text = viewModel.userRatingCount.abstractedNumberString + "개의 평가"
        ratingMiddleView.text = viewModel.averageRatingCount.formattedString(maxFractionDigits: 1)
        (ratingBottomView.arrangedSubviews[0] as! StarRatingView).setRating(rating: viewModel.averageRatingCount)
        
        ageMiddleView.text = viewModel.trackContentRating
        
        developerBottomView.text = viewModel.sellerName
        
        if viewModel.languageCodesISO2A.contains(where: { $0 == "KO" }) {
            langMiddleView.text = "KO"
            langBottomView.text = "한국어"
        }
        else {
            langMiddleView.text = viewModel.languageCodesISO2A.first ?? "없음"
            langBottomView.text = viewModel.languageCodesISO2A.first ?? "없음"
        }
        
        
    }
    
    
}
extension SearchDetailInfoView {
    
    
    private func maketopView(_ text : String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .gray
        label.text = text
        return label
    }
    private func makemiddleLabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        lb.textAlignment = .center
        lb.text = "4.1"
        return lb
    }
    
    private func makebottomLabel(_ text : String) -> UILabel {
        let lb = UILabel()
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textAlignment = .center
        lb.text = text
        return lb
    }
    
    private func setLayout(){
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(seperator)
        
        stackView.addArrangedSubview(ratingBox)
        stackView.addArrangedSubview(ageBox)
        stackView.addArrangedSubview(developerBox)
        stackView.addArrangedSubview(langBox)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            seperator.topAnchor.constraint(equalTo: scrollView.topAnchor),
            seperator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,constant: 15),
            seperator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,constant: -15),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            

            self.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        
    }
    
    
}
