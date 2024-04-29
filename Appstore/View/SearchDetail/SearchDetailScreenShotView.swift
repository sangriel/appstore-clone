//
//  SearchDetailScreenShotView.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class SearchDetailScreenShotView : UIView {
    
    
    
    lazy private var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: (200 *  696) / 392  )
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ScreenShotCollectionCell.self, forCellWithReuseIdentifier: ScreenShotCollectionCell.cellId)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        return cv
    }()
    
    
    
    private var imageUrls : [String] = []
    
    /**
     CollectionView의 셀을 눌렀을때 외부로 이벤트를 보내주기 위한 변수
     */
    var screenShotClickSubject = PublishSubject<Int>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        
    }
    
    func setImageUrls(imageUrls : [String]){
        self.imageUrls = imageUrls
        self.cv.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SearchDetailScreenShotView {
    private func setLayout(){
        self.addSubview(cv)
        
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: self.topAnchor),
            cv.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cv.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.heightAnchor.constraint(equalToConstant: (200 * 696) / 392  + 40)
        ])
        
    }
}
extension SearchDetailScreenShotView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenShotCollectionCell.cellId, for: indexPath) as! ScreenShotCollectionCell
        cell.setImageUrl(url: imageUrls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.screenShotClickSubject.onNext(indexPath.row)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {


        let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 패딩을 포함한 셀 하나의 넓이를 계산한다
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        

        var offset = targetContentOffset.pointee
        // ( 예상 정지 x좌표 / 셀 하나의 넓이)를 계산하여 몇번째 셀을 보고 있는지 확인한다
        let index = offset.x / cellWidthIncludingSpacing
        var roundedIndex : CGFloat = 0

        // targetContentOffset이 스크롤이 끝나는 지점을 예상하는 좌표이므로
        // scrollView.contentOffset(현재위치) 보다 작으면 오른쪽으로 드래깅 중인 상황으로 왼쪽의 셀을 보여준다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        }
        else {
            roundedIndex = ceil(index)
        }

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing,
                         y: -scrollView.contentInset.top)
        
        //계산된 값을 다시 예상 정지 지점에 넣어서 스크롤을 끝마친다
        targetContentOffset.pointee = offset
    }
    
    
    
    
    
    
}
