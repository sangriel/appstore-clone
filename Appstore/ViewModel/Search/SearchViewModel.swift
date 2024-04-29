//
//  SearchViewModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/19.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class SearchViewModel : NSObject, ViewModelType {
    
    
    enum SearchType {
        case onEmpty // 검색창이 비어있을 때
        case onSearch // 검색창에 텍스트를 입력하고 있을 때
        case onComplete // 검색을 완료 했을때
    }
    
    
    struct Input {
        let searchWord : Observable<String>
        let searchRequest : Observable<String>
        let showDetail : Observable<Int>
        
    }
    
    struct Output {
        let refreshTableView : Observable<Void>
        let showLoadingView : Observable<Bool>
        let showEmptyResultView : Observable<(Bool,String)>
        let showDetail : Observable<SearchResultModel>
        let searchType : BehaviorRelay<SearchType>
    }
    
    //CoreData에서 가져온 검색 키워드 원본 데이터 리스트
    private var searchWordDataList : [SearchWordModel] = []
    //TableView의 검색 키워드 Datasource, 원본 데이터 리스트에서 filter하여 생성한다
    private var searchWordViewModelList : [SearchWordCellViewModel] = []
    
    //서버에서 가져온 검색 결과 원본 데이터리스트
    private var searchResultDataList : [SearchResultModel] = []
    //TableView의 검색 결과 Datasource, 원본 데이터에서 필요한 정보만 mapping하여 생성한다.
    private var searchResultViewModelList : [SearchResultCellViewModel] = []
    
    
    private let currentSearchType = BehaviorRelay<SearchType>(value : .onEmpty)
    private var disposeBag = DisposeBag()
    
    
    
    private var coreDataManager : CoreDataManagerDelegate!
    private var searchService : SearchServiceDelegate!
    
    init(coreDataManager : CoreDataManagerDelegate = CoreDataManager(),
         searchService : SearchServiceDelegate = SearchService()){
        super.init()
        self.coreDataManager = coreDataManager
        self.searchService = searchService
        setSearchWordDataList()
        
        
    }
    
    
    private func setSearchWordDataList() {
        searchWordDataList = coreDataManager.getDataList()
    }
    
    private func refreshsearchWordViewModelList(searchWord : String){
        if searchWord == "" {
            searchWordViewModelList = searchWordDataList.map({ SearchWordCellViewModel(keyWord: $0.keywords) })
        }
        else {
            searchWordViewModelList = searchWordDataList
                .filter({ $0.keywords.lowercased().contains(searchWord.lowercased()) })
                .map({ SearchWordCellViewModel(keyWord: $0.keywords) })
        }
        
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let refreshTableView = PublishSubject<Void>()
        let showEmptyResultView = PublishSubject<(Bool,String)>()
        let showLoadingView = PublishSubject<Bool>()
        let showDetail = PublishSubject<SearchResultModel>()
        
        // 플로우
        // 키워드에 따른 현재 상태 설정 -> 검색 키워드 DataSource가공 -> TableView.reloadData
        input.searchWord
            .distinctUntilChanged({ oldVal, newVal in
                // UISearchBar가 빈칸일때 programmatic하게 텍스트를 입력할 경우 searchWord의 이벤트가 발생되지 않음
                // 따라서 clearTextBtn이나 Cancel버튼을 누를시 "" -> "" 이벤트 방출로 인식하여 검열되는 것을 방지
                if newVal == "" {
                    return false
                }
                return oldVal == newVal
            })
            .flatMap{ [weak self] searchWord -> Observable<Void> in
                showEmptyResultView.onNext((false, ""))
                guard let self = self else { return Observable.error(CustomError.selfDeallocated)}
                self.currentSearchType.accept( searchWord == "" ? .onEmpty : .onSearch)
                self.refreshsearchWordViewModelList(searchWord: searchWord)
                return .just(())
            }
            .bind(to: refreshTableView)
            .disposed(by: disposeBag)
        
        // 플로우
        // 로딩화면 실행 -> 현재 상태를 .onComplete로 설정 -> 서버에 요청 -> 로딩화면 종료 -> 원본데이터,datasource가공
        // -> CoreData에 키워드 추가 -> TableView.reloadData
        input.searchRequest
            .flatMap { [weak self] searchWord -> Observable<([SearchResultModel],String)> in
                guard let self = self else { return Observable.error(CustomError.selfDeallocated)}
                showLoadingView.onNext(true)
                self.currentSearchType.accept(.onComplete)
                return self.networkFetchRequest(searchWord: searchWord)
            }
            .flatMap { [weak self] datas, searchWord -> Observable<Void> in
                showLoadingView.onNext(false)
                guard let self = self else { return Observable.error(CustomError.selfDeallocated)}
                self.setSearchResultModels(datas: datas)
                self.parseToSearchResultCellViewModel(datas: datas)
                showEmptyResultView.onNext((datas.count == 0, datas.count == 0 ? searchWord : ""))
                if datas.count != 0 {
                    self.addDataToCoreModel(searchWord: searchWord)
                }
                return .just(())
            }
            .bind(to: refreshTableView)
            .disposed(by: disposeBag)
        
        // 플로우
        // indexPath.row를 기반으로 DataSource에서 번들아이디 추출 -> 번들아이디가 일치하는 원본데이터를 넘겨줌
         input.showDetail
            .flatMap{ [weak self] index -> Observable<SearchResultModel> in
                guard let self = self else { return Observable.error(CustomError.selfDeallocated) }
                let bundleId = self.searchResultViewModelList[index].bundleId
                let result = self.searchResultDataList.first(where: { $0.bundleId == bundleId })!
                return .just(result)
            }
            .bind(to: showDetail)
            .disposed(by: disposeBag)

            
        return Output(refreshTableView: refreshTableView,
                      showLoadingView: showLoadingView,
                      showEmptyResultView: showEmptyResultView,
                      showDetail: showDetail,
                      searchType : currentSearchType)
    }
    
    
    private func networkFetchRequest(searchWord : String) -> Observable<([SearchResultModel],String)> {
        return self.searchService.fetch(term: searchWord)
            .map { result -> ([SearchResultModel],String) in
                switch result {
                case .success(let data):
                    return (data.results,searchWord)
                case .error(_):
                    return ([],searchWord)
                }
            }
    }
    
    private func addDataToCoreModel(searchWord : String) {
        if !coreDataManager.isEntityDuplicated(dataList: searchWordDataList, searchWord: searchWord) {
            coreDataManager.addData(searchWord: searchWord)
            setSearchWordDataList()
        }
    }
    
    private func setSearchResultModels(datas : [SearchResultModel]) {
        self.searchResultDataList = datas
    }
    
    private func parseToSearchResultCellViewModel(datas : [SearchResultModel]){
        searchResultViewModelList.removeAll()
        for item in datas {
            let viewModel = SearchResultCellViewModel(appIconUrl: item.artworkUrl100!,
                                                      titleLabel: item.trackName!,
                                                      subTitleLabel: item.genres!.prefix(3).joined(separator: ","),
                                                      averageRating: item.averageUserRating!,
                                                      userRatingCount: item.userRatingCount!,
                                                      screenShotUrls: item.screenshotUrls!,
                                                      bundleId: item.bundleId!)
            searchResultViewModelList.append(viewModel)
        }
    }
    
    
}
extension SearchViewModel : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSearchType.value == .onEmpty || currentSearchType.value == .onSearch {
            return searchWordViewModelList.count
        }
        else {
            return searchResultViewModelList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSearchType.value == .onEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchWordCell.cellId, for: indexPath) as! RecentSearchWordCell
            cell.setViewModel(viewModel: searchWordViewModelList[indexPath.row])
            return cell
        }
        else if currentSearchType.value == .onSearch {
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchSearchWordCell.cellId, for: indexPath) as! MatchSearchWordCell
            cell.setViewModel(viewModel: searchWordViewModelList[indexPath.row])
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellId, for: indexPath) as! SearchResultCell
            
            cell.setViewModel(viewModel: searchResultViewModelList[indexPath.row])
            return cell
        }
    
    }
    
}
