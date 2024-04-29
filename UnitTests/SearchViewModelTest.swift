//
//  SearchViewModelTest.swift
//  KakoBank_HWTests
//
//  Created by sangmin han on 2023/03/19.
//

import XCTest
import RxTest
import RxSwift
@testable import KakoBank_HW


final class SearchServiceMock : SearchServiceDelegate {
    
    
    private let bundle = Bundle(identifier: "hsm.UnitTests")!
    private func makeMockData(fileName : String) -> SearchResultListModel {
        let path = bundle.path(forResource: fileName, ofType: "json")!
        let jsonString = try! String(contentsOfFile: path)
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        let result = try! decoder.decode(SearchResultListModel.self, from: data!)
        return result
    }
    
    
    func fetch(term: String) -> Observable<NetWorkResult<SearchResultListModel>> {
        
        if term == "" || term == "termWithEmptyResult" {
            return Observable<NetWorkResult<SearchResultListModel>>
                .just(.success(makeMockData(fileName: "EmptySearchJSON")))
        }
        else {
            return Observable<NetWorkResult<SearchResultListModel>>
                .just(.success(makeMockData(fileName: "FilledSearchJSON")))
        }
    }
    
}

final class CoreDataMock : CoreDataManagerDelegate {
    
    var dataList : [String] = []
    func getDataList() -> [SearchWordModel] {
        return dataList.map{ SearchWordModel(keywords: $0) }
    }
    
    func addData(searchWord: String) {
        if searchWord == "" {
            return
        }
        dataList.append(searchWord)
    }
    
    func isEntityDuplicated(dataList: [SearchWordModel], searchWord: String) -> Bool {
        return dataList.contains(where: { $0.keywords == searchWord })
    }
    
}


final class SearchViewModelTest: XCTestCase {

    
    var searchServiceMock : SearchServiceMock!
    var coreDataMock : CoreDataMock!
    var viewModel : SearchViewModel!
    
    let searchWordInputSubject = PublishSubject<String>()
    let searchRequestInputSubject = PublishSubject<String>()
    let showDetailInputSubject = PublishSubject<Int>()
    
    lazy var input = SearchViewModel.Input(searchWord: searchWordInputSubject,
                                           searchRequest: searchRequestInputSubject,
                                           showDetail: showDetailInputSubject)
    
    private var disposeBag = DisposeBag()
    
    
    override func setUp() {
        self.searchServiceMock = SearchServiceMock()
        self.coreDataMock = CoreDataMock()
        self.viewModel = SearchViewModel(coreDataManager: coreDataMock ,searchService: searchServiceMock)
        super.setUp()
        
        
    }
    
    func testSearchWordInput(){
        
        let scheduler = TestScheduler(initialClock: 0)

        let searchType = scheduler.createObserver(SearchViewModel.SearchType.self)

        let output = viewModel.transform(input: input)

        output.searchType
            .bind(to: searchType)
            .disposed(by: disposeBag)


        scheduler.createColdObservable(
            [.next(1, "abc"),
             .next(2, ""),
             .next(3, ""),
             .next(4, "add")])
            .bind(to: searchWordInputSubject)
            .disposed(by: disposeBag)



        scheduler.start()

        XCTAssertEqual(searchType.events,
                       [.next(0, .onEmpty),
                        .next(1, .onSearch),
                        .next(2, .onEmpty),
                        .next(3, .onEmpty),
                        .next(4, .onSearch)])
        
    }
    
    func testSearchRequestInput(){
        let scheduler = TestScheduler(initialClock: 0)
        
        let searchType = scheduler.createObserver(SearchViewModel.SearchType.self)
        
        let output = viewModel.transform(input: input)
        
        
        output.searchType
            .bind(to: searchType)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(1, "kakao")])
        .bind(to: searchRequestInputSubject)
        .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(searchType.events,
                       [.next(0, .onEmpty),
                        .next(1, .onComplete)])
        
        
        
    }
    
    func testCurrentSearchTypeWithSearchWordAndSearchRequest(){
        let scheduler = TestScheduler(initialClock: 0)
        
        let searchType = scheduler.createObserver(SearchViewModel.SearchType.self)
        
        let output = viewModel.transform(input: input)
        
        
        output.searchType
            .bind(to: searchType)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(1, "asf"),
            .next(3, ""),
            .next(4, "abc")])
        .bind(to: searchWordInputSubject)
        .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(2, "asdfd"),
            .next(10, "asdfs")])
        .bind(to: searchRequestInputSubject)
        .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(searchType.events,
                       [.next(0, .onEmpty),
                        .next(1, .onSearch),
                        .next(2, .onComplete),
                        .next(3, .onEmpty),
                        .next(4, .onSearch),
                        .next(10, .onComplete)])
        
        
        
    }
    
    
    func testEmptyResultView() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let showEmptyResultViewBool = scheduler.createObserver(Bool.self)
        let showEmptyResultViewString = scheduler.createObserver(String.self)
        
        
        let output = viewModel.transform(input: input)
        
        
        
        output.showEmptyResultView
            .map{ $0.0 }
            .bind(to: showEmptyResultViewBool)
            .disposed(by: disposeBag)
        
        output.showEmptyResultView
            .map{ $0.1 }
            .bind(to: showEmptyResultViewString)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(2, ""),
            .next(4, "asdf"),
            .next(5, "termWithEmptyResult")])
        .bind(to: searchRequestInputSubject)
        .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(3, "asdf")])
        .bind(to: searchWordInputSubject)
        .disposed(by: disposeBag)
        
        
        scheduler.start()
        
        XCTAssertEqual(showEmptyResultViewBool.events,
                       [
                        .next(2, true),
                        .next(3, false),
                        .next(4, false),
                        .next(5, true)
                       ])
        
        XCTAssertEqual(showEmptyResultViewString.events,
                       [
                        .next(2, ""),
                        .next(3, ""),
                        .next(4, ""),
                        .next(5, "termWithEmptyResult")
                       ])
        
    }
    
    
    func testCoreDataManagerAddDataToCoreModel(){
        
        let scheduler = TestScheduler(initialClock: 0)
        
        _ = viewModel.transform(input: input)
        
        
        scheduler.createColdObservable([
            .next(1, "one"),
            .next(2, "two"),
            .next(3, "")])
        .bind(to: searchRequestInputSubject)
        .disposed(by: disposeBag)
        
        
        
        scheduler.scheduleAt(0) { [weak self]  in
            guard let self = self else {
                return
            }
            XCTAssertEqual(self.coreDataMock.dataList, [])
        }
        
        scheduler.scheduleAt(1) { [weak self]  in
            guard let self = self else {
                return
            }
            XCTAssertEqual(self.coreDataMock.dataList, ["one"])
        }
        
        scheduler.scheduleAt(2) { [weak self]  in
            guard let self = self else {
                return
            }
            
            XCTAssertEqual(self.coreDataMock.dataList, ["one","two"])
        }
        
        scheduler.scheduleAt(3) { [weak self]  in
            guard let self = self else {
                return
            }
            
            XCTAssertEqual(self.coreDataMock.dataList, ["one","two"])
        }
        
        scheduler.start()
        
        
    }
    
    
    
    func testShowDetail(){
        let scheduler = TestScheduler(initialClock: 0)
    
        
        let showDetail = scheduler.createObserver(String.self)
        
        let output = viewModel.transform(input: input)
        
        output.showDetail
            .map{ $0.trackName! }
            .bind(to: showDetail)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(2, "sdf"),
            .next(4, "asdf"),
            .next(5, "asdf")])
        .bind(to: searchRequestInputSubject)
        .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(4, 0)])
        .bind(to: showDetailInputSubject)
        .disposed(by: disposeBag)
        
        
        scheduler.start()
        
        
        XCTAssertEqual(showDetail.events, [.next(4, "카카오톡")])
        
        
        
    }
    
    
    

}
