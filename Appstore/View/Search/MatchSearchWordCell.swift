//
//  MatchSearchWordCell.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit


class MatchSearchWordCell : UITableViewCell {
    
    
    static let cellId = "matchsearchwordcellId"
    
    let keyWordLabel : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return lb
    }()
    
    let magnifyIcon : UIImageView = {
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let seperator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    var viewModel : SearchWordCellViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(viewModel : SearchWordCellViewModel){
        self.viewModel = viewModel
        keyWordLabel.text = viewModel.keyWord
    }
    
    
}
extension MatchSearchWordCell {
    private func setLayout(){
        contentView.addSubview(magnifyIcon)
        contentView.addSubview(keyWordLabel)
        contentView.addSubview(seperator)
        
        
        NSLayoutConstraint.activate([
            magnifyIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            magnifyIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            magnifyIcon.widthAnchor.constraint(equalToConstant: 20),
            magnifyIcon.heightAnchor.constraint(equalToConstant: 20),
            
            keyWordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            keyWordLabel.leadingAnchor.constraint(equalTo: magnifyIcon.trailingAnchor, constant: 10),
            keyWordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            seperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            
            contentView.bottomAnchor.constraint(equalTo: keyWordLabel.bottomAnchor,constant : 10)
        ])
        
    }
}
