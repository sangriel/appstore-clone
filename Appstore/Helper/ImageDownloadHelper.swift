//
//  ImageDownloadHelper.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation
import RxSwift

class ImageDownLoader {
    static let shared = ImageDownLoader()
    private init(){}
    
    //이미지 캐싱을 위한 변수
    private let cache = NSCache<NSString,NSData>()
    
    func download(imageUrl : String) -> Observable<Data> {
        return Observable<Data>.create { [unowned self] seal  in
            // 이미지가 캐싱 되어 있으면 다운로드하지 않고 바로 반환
            if let imageData = cache.object(forKey: imageUrl as NSString) {
                seal.onNext(imageData as Data)
                seal.onCompleted()
                return Disposables.create{ }
            }
            
            guard let URL = URL(string: imageUrl) else {
                seal.onError(CustomError.error("invalid url"))
                return Disposables.create{ }
            }
            
            let task = URLSession.shared.downloadTask(with: URL) { [unowned self] url, response, error in
                if let error = error {
                    seal.onError(error)
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    seal.onError(CustomError.error(
                        "HTTP Error - status code \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                    ))
                    return
                }
                
                guard let url = url else {
                    seal.onError(CustomError.error("invalid url"))
                    return 
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    //캐싱 되어 있지 않으면 캐싱 변수에 이미지 데이터를 저장한다
                    self.cache.setObject(data as NSData, forKey: imageUrl as NSString)
                    seal.onNext(data)
                    seal.onCompleted()
                }
                catch( let error ) {
                    seal.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create{ }
        }
    }
}
