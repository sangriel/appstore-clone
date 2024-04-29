//
//  SearchViewController.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/19.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa


class SearchViewController : UIViewController {
    

    
    let searchController = UISearchController(searchResultsController: nil)
    
    let userProfileIconView : UIImageView = {
        let userProfileIcon = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = userProfileIcon
        imgView.tintColor = .systemBlue
        return imgView
    }()
    
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = viewModel
        tableView.register(RecentSearchWordCell.self, forCellReuseIdentifier: RecentSearchWordCell.cellId)
        tableView.register(MatchSearchWordCell.self, forCellReuseIdentifier: MatchSearchWordCell.cellId)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellId)
        tableView.register(TableRecentSearchWordHeaderView.self, forHeaderFooterViewReuseIdentifier: TableRecentSearchWordHeaderView.headerViewId)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 1
        }
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
    
        return tableView
    }()
    
    private let loadingView : LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = true
        return loadingView
    }()
    
    private let emptyResultView : EmptyResultView = {
        let emptyResultView = EmptyResultView()
        emptyResultView.translatesAutoresizingMaskIntoConstraints = false
        emptyResultView.isHidden = true
        return emptyResultView
    }()
    
    private var viewModel : SearchViewModel!

    //TableViewCell을 클릭하여 검색을 시도할때 사용
    private let searchWordSubject = PublishSubject<String>()
    //TableViewCelld을 클릭하여 상세화면으로 이동할때 사용
    private let showDetailSubject = PublishSubject<Int>()
    private var currentSearchType : SearchViewModel.SearchType!
    private var disposeBag = DisposeBag()
    
    init(viewModel : SearchViewModel = SearchViewModel()){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        setSearchController()
        setNavigationItem()
        
        
        setLayout()
        bindViewModel()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addUserProfileIconViewOnLargeTitle()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.userProfileIconView.alpha = 1
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.userProfileIconView.alpha = 0
        }
    }
    
    
    private func bindViewModel(){
        
        let searchRequest = Observable.merge(
            searchController.searchBar.rx.searchButtonClicked
                .map{ [weak self] _ -> String in
                    return self?.searchController.searchBar.text ?? ""
                },
            searchWordSubject
        )
        
        let searchWord = Observable.merge(
            searchController.searchBar.rx.text.orEmpty.asObservable(),
            searchController.searchBar.rx.cancelButtonClicked.map{ "" }.asObservable()
        )
        
        
        let input = SearchViewModel.Input(searchWord: searchWord,
                                          searchRequest: searchRequest,
                                          showDetail: showDetailSubject)
        
        
        let output = viewModel.transform(input: input)
        
        
        output.showDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext : { [weak self] data in
                let viewModel = SearchDetailViewModel(data: data)
                let vc = SearchDetailViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showEmptyResultView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext : { [weak self] show, searchWord in
                self?.emptyResultView.setSearchWord(searchWord: searchWord)
                self?.emptyResultView.isHidden = !show
            })
            .disposed(by: disposeBag)
        
        output.showLoadingView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext : { [weak self] show in
                if show {
                    self?.loadingView.startAnimate()
                }
                else {
                    self?.loadingView.stopAnimate()
                }
            })
            .disposed(by: disposeBag)
        
        output.refreshTableView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext : { [weak self] in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.searchType
            .subscribe(onNext : { [weak self] searchType in
                self?.currentSearchType = searchType
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func setSearchController(){
        self.navigationItem.searchController = searchController
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
    }
    
    private func setNavigationItem(){
        self.navigationItem.title = "검색"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addUserProfileIconViewOnLargeTitle() {
        guard let largeTitleView = getLargeTitleView() else {
            return
        }
        if largeTitleView.subviews.contains(where: { $0 == userProfileIconView }) { return }
        largeTitleView.addSubview(userProfileIconView)
        NSLayoutConstraint.activate([
            userProfileIconView.trailingAnchor.constraint(equalTo: largeTitleView.trailingAnchor, constant: -25),
            userProfileIconView.bottomAnchor.constraint(equalTo: largeTitleView.bottomAnchor, constant: -12),
            userProfileIconView.widthAnchor.constraint(equalToConstant: 35),
            userProfileIconView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    /**
     navigationBar의 LargeTitleView를 찾는 함수, 애플이 자체적으로 class이름 변경시 작동 불가능
     */
    private func getLargeTitleView() -> UIView? {
        guard let largeTitleView = NSClassFromString("_UINavigationBarLargeTitleView") else {
            return nil
        }
        return navigationController?.navigationBar.subviews.filter{ $0.isKind(of: largeTitleView) }.first
    }
    
}
extension SearchViewController {
    private func setLayout(){
        self.view.addSubview(tableView)
        self.view.addSubview(loadingView)
        self.view.addSubview(emptyResultView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            emptyResultView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            emptyResultView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emptyResultView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            emptyResultView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentSearchType == .onEmpty || self.currentSearchType == .onSearch {
            searchController.searchBar.resignFirstResponder()
            
            if let cell = tableView.cellForRow(at: indexPath) as? RecentSearchWordCell {
                searchController.searchBar.text = cell.viewModel.keyWord
                searchWordSubject.onNext(cell.viewModel.keyWord)
            }
            else if let cell = tableView.cellForRow(at: indexPath) as? MatchSearchWordCell {
                searchController.searchBar.text = cell.viewModel.keyWord
                searchWordSubject.onNext(cell.viewModel.keyWord)
            }
           
        }
        else {
            showDetailSubject.onNext(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.currentSearchType == .onEmpty {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableRecentSearchWordHeaderView.headerViewId) as! TableRecentSearchWordHeaderView
            
            return view
        }
        else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.currentSearchType == .onEmpty {
            return 40 + 20
        }
        else {
            return 0
        }
    }
}
