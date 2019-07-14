//
//  HomeViewModel.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    let data: Observable<[Movie]>
    let error: Observable<Error?>
    let processing: Observable<Bool>
    let searchText = BehaviorSubject<String?>(value: "")
    
    init() {
        
//        let result = search
//            .filter { $0 != nil && ($0?.count ?? 0) > 0 }
//            .map { $0! }
//            .flatMapLatest { [weak self] text -> Observable<[Movie]> in
//                return DataManager.shared.getMovies(with: text).catchErrorJustReturn([])
//            }
//            .observeOn(MainScheduler.instance)
//            .share()
        
        let result = searchText
            .filter { $0 != nil && !($0?.isEmpty ?? true) }
            .map { $0! }
            .flatMapLatest { text -> Observable<Event<[Movie]>> in
                return DataManager.shared.getMovies(with: text)
                    .debug("data manager get movies", trimOutput: false)
                    .materialize()
            }
            .debug("movie search result", trimOutput: false)
            .observeOn(MainScheduler.instance)
            .share()
        
//        let result = searchText
//            .filter { $0 != nil && !($0?.isEmpty ?? true) }
//            .map { $0! }
//            .flatMapLatest { text -> Observable<[Movie]> in
//                return DataManager.shared.getMovies(with: text)//.materialize()
//            }
//            .debug("movie search result", trimOutput: false)
//            .observeOn(MainScheduler.instance)
//            .share()
        
        data = result
            .filter { $0.element != nil}
            .map {
                $0.element!
            }
        
        error = result
            .map { $0.error }
            .share()
        
        processing = Observable<Bool>
            .merge( searchText.map { _ in true }, data.map { _ in false }, error.map { _ in false} )
    }
    
}
