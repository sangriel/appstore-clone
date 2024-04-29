//
//  SearchResultCell.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class SearchResultCell : UITableViewCell {
    
    static let cellId = "searchresultcellid"
    
    private let appIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.text = "test"
        return label
    }()
    
    private let subTitleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "test"
        return label
    }()
    
    private let ratingView : StarRatingView = {
        let ratingView = StarRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    private let ratingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.text = "test"
        return label
    }()
    
    private let downloadBtn : UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let screehShotImageViews : [UIImageView] = {
        var imageViews : [UIImageView] = []
        for _ in 0...2 {
            let imageView = UIImageView()
            imageView.backgroundColor = .systemGray6
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 0.5
            imageView.layer.borderColor = UIColor.systemGray4.cgColor
            imageView.contentMode = .scaleAspectFill
            imageViews.append(imageView)
        }
        return imageViews
    }()
    
    
    private var viewModel : SearchResultCellViewModel!
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setViewModel(viewModel : SearchResultCellViewModel){
        appIconImageView.image = nil
        screehShotImageViews.forEach { view in
            view.image = nil
        }
        
        self.viewModel = viewModel
        ImageDownLoader.shared.download(imageUrl: viewModel.appIconUrl)
            .map{ UIImage(data:$0) }
            .bind(to: appIconImageView.rx.image)
            .disposed(by: disposeBag)
        
        titleLabel.text = viewModel.titleLabel
        subTitleLabel.text = viewModel.subTitleLabel
        ratingLabel.text = viewModel.userRatingCount
        ratingView.setRating(rating: viewModel.averageRating)
        
        for i in 0 ..< min(viewModel.screenShotUrls.count,3) {
            ImageDownLoader.shared.download(imageUrl: viewModel.screenShotUrls[i])
                .map{ UIImage(data: $0) }
                .bind(to: screehShotImageViews[i].rx.image)
                .disposed(by: disposeBag)
        }
    }
    
}
extension SearchResultCell {
    private func setLayout(){
        
        let ratingContainer = UIView()
        ratingContainer.addSubview(ratingView)
        ratingContainer.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            ratingView.centerYAnchor.constraint(equalTo: ratingContainer.centerYAnchor),
            ratingView.leadingAnchor.constraint(equalTo: ratingContainer.leadingAnchor),
            ratingView.widthAnchor.constraint(equalToConstant: 15 * 4 ),
            ratingView.heightAnchor.constraint(equalToConstant: 15),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingContainer.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingView.trailingAnchor,constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingContainer.trailingAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: 14),
            
            ratingContainer.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel,subTitleLabel,ratingContainer])
        labelStackView.axis = .vertical
        
        
        let topInfoStack = UIStackView(arrangedSubviews: [appIconImageView,labelStackView,downloadBtn])
        topInfoStack.translatesAutoresizingMaskIntoConstraints = false
        topInfoStack.spacing = 12
        topInfoStack.alignment = .center
        
        
        NSLayoutConstraint.activate([
            appIconImageView.widthAnchor.constraint(equalToConstant: 64),
            appIconImageView.heightAnchor.constraint(equalToConstant: 64),
            
            downloadBtn.widthAnchor.constraint(equalToConstant: 60)
            
        ])
        
        let screenShotStack = UIStackView(arrangedSubviews: screehShotImageViews)
        screenShotStack.axis = .horizontal
        screenShotStack.spacing = 10
        screenShotStack.distribution = .fillEqually
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let screenShotHeight : CGFloat = ((screenWidth - 40) / 3) * (screenHeight / screenWidth)
        
        
        let fullStack = UIStackView(arrangedSubviews: [ topInfoStack, screenShotStack])
        fullStack.translatesAutoresizingMaskIntoConstraints = false
        fullStack.axis = .vertical
        fullStack.spacing = 10
        fullStack.isLayoutMarginsRelativeArrangement = true
        fullStack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        contentView.addSubview(fullStack)
        NSLayoutConstraint.activate([
            
            screenShotStack.heightAnchor.constraint(equalToConstant: screenShotHeight),
            
            fullStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            fullStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fullStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fullStack.heightAnchor.constraint(lessThanOrEqualToConstant: 64 + 30 + screenShotHeight),
            
            contentView.bottomAnchor.constraint(equalTo: fullStack.bottomAnchor)
            
        ])
    }
    
    
}
