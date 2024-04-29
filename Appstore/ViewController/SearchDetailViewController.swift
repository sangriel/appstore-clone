//
//  SearchDetailViewController.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchDetailViewController : UIViewController {
    
    
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private let titleView = SearchDetailTitleView()
    private let infoView = SearchDetailInfoView()
    private let screenShotView = SearchDetailScreenShotView()
    private let descriptionView = SearchDetailDescriptionView()
    private let newFeatureView = SearchDetailNewFeatureView()
    
    
    private var viewModel : SearchDetailViewModel!
    private var disposeBag = DisposeBag()
    
    init(viewModel : SearchDetailViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        setLayout()
        bindViewModel()
        
    }
    
    private func bindViewModel(){
        
        let input = SearchDetailViewModel.Input(showScreenShotZoom: screenShotView.screenShotClickSubject)
        
        let output = viewModel.transform(input: input)
        
        output.titleViewModel
            .subscribe(onNext : { [weak self] viewModel in
                self?.titleView.setViewModel(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        output.infoViewModel
            .subscribe(onNext : { [weak self] viewModel in
                self?.infoView.setViewModel(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        output.screenShotUrls
            .subscribe(onNext : { [weak self] screenShotUrls in
                self?.screenShotView.setImageUrls(imageUrls: screenShotUrls)
            })
            .disposed(by: disposeBag)
        
        output.descriptionViewModel
            .subscribe(onNext : { [weak self] viewModel in
                self?.descriptionView.setViewModel(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        output.newFeatureViewModel
            .subscribe(onNext : { [weak self] viewModel in
                self?.newFeatureView.setViewModel(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        output.showSreenShotZoomView
            .subscribe(onNext : { [weak self] index, urls in
                if urls.isEmpty { return }
                let vc = ScreenShotZoomViewController(imageUrls: urls, initialIndex: index)
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)

        
    }
    
    
    
}
extension SearchDetailViewController {
    private func setLayout(){
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(screenShotView)
        stackView.addArrangedSubview(descriptionView)
        stackView.addArrangedSubview(newFeatureView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
    }
}
