//
//  SearchDetailViewModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class SearchDetailViewModel : ViewModelType {
    
    struct Input {
        let showScreenShotZoom : Observable<Int>
    }
    
    struct Output {
        let titleViewModel : BehaviorRelay<SearchDetailTitleViewModel>
        let infoViewModel : BehaviorRelay<SearchDetailInfoViewModel>
        let screenShotUrls : BehaviorRelay<[String]>
        let descriptionViewModel : BehaviorRelay<SearchDetailDescriptionViewModel>
        let newFeatureViewModel : BehaviorRelay<SearchDetailNewFeatureViewModel>
        let showSreenShotZoomView : Observable<(Int,[String])>
    }
    
    
    private let data : SearchResultModel!
    
    private var disposeBag = DisposeBag()
    
    init(data : SearchResultModel){
        self.data = data
    }
    
    func transform(input: Input) -> Output {
        
        let titleViewModel = BehaviorRelay<SearchDetailTitleViewModel>(value : makeTitleViewModel())
        
        let infoViewModel = BehaviorRelay<SearchDetailInfoViewModel>(value : makeInfoViewModel())
        
        let screenShotUrls = BehaviorRelay<[String]>(value: data.screenshotUrls!)
        
        let descriptionViewModel = BehaviorRelay<SearchDetailDescriptionViewModel>(value: makeDescriptionViewModel())
        
        let newFeatureViewModel = BehaviorRelay<SearchDetailNewFeatureViewModel>(value: makeNewFeatureViewModel())
        

        let showImageZoom = input.showScreenShotZoom
            .map{ [weak self] index -> (Int,[String]) in
                guard let self = self else { return (0,[])}
                return (index, self.data.screenshotUrls!)
            }
            
        
        return Output(titleViewModel: titleViewModel,
                      infoViewModel: infoViewModel,
                      screenShotUrls: screenShotUrls,
                      descriptionViewModel: descriptionViewModel,
                      newFeatureViewModel: newFeatureViewModel,
                      showSreenShotZoomView: showImageZoom)
        
    }
    
    
    private func makeTitleViewModel() -> SearchDetailTitleViewModel{
        
        return SearchDetailTitleViewModel(appIconUrl: data.artworkUrl60!,
                                          title: data.trackName!,
                                          subTitle: data.genres!.prefix(3).joined(separator: ","))
    }
    
    private func makeInfoViewModel() -> SearchDetailInfoViewModel {
        return SearchDetailInfoViewModel(userRatingCount: data.userRatingCount!,
                                         averageRatingCount: data.averageUserRating!,
                                         trackContentRating: data.trackContentRating!,
                                         sellerName: data.sellerName!,
                                         languageCodesISO2A: data.languageCodesISO2A!)
    }
    
    private func makeDescriptionViewModel() -> SearchDetailDescriptionViewModel {
        return SearchDetailDescriptionViewModel(description: data.description!,
                                                sellerName: data.sellerName!)
    }
    
    private func makeNewFeatureViewModel() -> SearchDetailNewFeatureViewModel {
        return SearchDetailNewFeatureViewModel(releaseNotes: data.releaseNotes!,
                                               currentVersionReleaseDate: data.currentVersionReleaseDate!,
                                               version: data.version!)
    }
    
}
