//
//  ScreenShotZoomViewController.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class ScreenShotZoomViewController : UIViewController {
    
    lazy private var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
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
    
    private let closeBtn : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("완료", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return btn
    }()
    
    private var imageUrls : [String] = []
    private var initialIndex : Int = 0
    private var disposeBag = DisposeBag()
    
    init(imageUrls : [String], initialIndex : Int){
        super.init(nibName: nil, bundle: nil)
        self.imageUrls = imageUrls
        self.initialIndex = initialIndex
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayout()
        
        bindView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToInitialIndex()
    }
    
    private func scrollToInitialIndex(){
        cv.scrollToItem(at: IndexPath(row: initialIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    private func bindView(){
        
        closeBtn.rx.tap
            .subscribe(onNext : { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    
}
extension ScreenShotZoomViewController {
    private func setLayout(){
        self.view.addSubview(closeBtn)
        self.view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            closeBtn.widthAnchor.constraint(equalToConstant: 60),
            closeBtn.heightAnchor.constraint(equalToConstant: 40),
            
            cv.topAnchor.constraint(equalTo: closeBtn.bottomAnchor,constant:  10),
            cv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant:  -20)
        ])
        
    }
}
extension ScreenShotZoomViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenShotCollectionCell.cellId, for: indexPath) as! ScreenShotCollectionCell
        cell.setImageUrl(url: imageUrls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 80, height: collectionView.frame.height)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
        // 패딩을 포함한 셀 하나의 넓이를 계산한다
        let cellWidthIncludingSpacing = (self.view.frame.width - 80) + layout.minimumLineSpacing
        

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
