//
//  ScreenShotCollectionCell.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class ScreenShotCollectionCell : UICollectionViewCell {
    
    
    static let cellId = "screenshotcollectioncellid"
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageUrl(url : String){
        imageView.image = nil
        ImageDownLoader.shared.download(imageUrl: url)
            .map{ UIImage(data: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    
}
extension ScreenShotCollectionCell {
    private func setLayout(){
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
}
