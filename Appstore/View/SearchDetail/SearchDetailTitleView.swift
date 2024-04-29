//
//  SearchDetailTitleView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class SearchDetailTitleView : UIView {
    
    private let appIconView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel : UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 18,weight: .bold)
        label.textColor = .black
        label.isEditable = false
        label.isScrollEnabled = false
        label.textContainer.maximumNumberOfLines = 2
        label.textContainer.lineFragmentPadding = .zero
        label.textContainerInset = .zero
        label.textContainer.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let subTitleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let downloadBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("받기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    private let shareBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()

    
    private var viewModel : SearchDetailTitleViewModel!
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    func setViewModel(viewModel : SearchDetailTitleViewModel){
        self.viewModel = viewModel
        ImageDownLoader.shared.download(imageUrl: viewModel.appIconUrl)
            .map{ UIImage(data: $0) }
            .bind(to: appIconView.rx.image)
            .disposed(by: disposeBag)
        
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        
    }
    
    
    
}
extension SearchDetailTitleView {
    
    private func setLayout(){
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel,subTitleLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 2
        
        let btnStack = UIStackView(arrangedSubviews: [downloadBtn,shareBtn])
        btnStack.axis = .horizontal
        btnStack.distribution = .equalSpacing
        
        let vStack = UIStackView(arrangedSubviews: [labelStack,btnStack])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        
        let fullStack = UIStackView(arrangedSubviews: [appIconView,vStack])
        fullStack.translatesAutoresizingMaskIntoConstraints = false
        fullStack.axis = .horizontal
        fullStack.spacing = 10
        fullStack.isLayoutMarginsRelativeArrangement = true
        fullStack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        self.addSubview(fullStack)
        
        NSLayoutConstraint.activate([
            appIconView.widthAnchor.constraint(equalToConstant: 100),
            
            downloadBtn.widthAnchor.constraint(equalToConstant: 60),
            shareBtn.widthAnchor.constraint(equalToConstant: 30),
            
            fullStack.topAnchor.constraint(equalTo: self.topAnchor),
            fullStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fullStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            fullStack.heightAnchor.constraint(equalToConstant: 130),
            
            
            self.bottomAnchor.constraint(equalTo: fullStack.bottomAnchor)
        ])
        
    }
}

