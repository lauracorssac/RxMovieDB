//
//  HomeViewModel.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import Foundation
import RxSwift

// SECOND VIEW MODEL -  TREATS ERROR, BUT EMPTY STATE = ERROR

class HomeViewModel1 {
    
    let data: Observable<[Movie]>
    let error: Observable<Error?>
    let processing: Observable<Bool>
    let searchText = BehaviorSubject<String?>(value: "")
    let isEmptyState: Observable<Bool>
    
    init() {
        
        let filteredSearchText = searchText
            .filter { $0 != nil && !($0?.isEmpty ?? true) }
            .map { $0! }
            .share()
        
        let result = searchText
            .filter { $0 != nil && !($0?.isEmpty ?? true) }
            .map { $0! }
            .flatMapLatest { text -> Observable<[Movie]> in
                return DataManager.shared.getMovies(with: text).catchErrorJustReturn([])
            }
            .debug("movie search result", trimOutput: false)
            .observeOn(MainScheduler.instance)
            .share()
        
        data = result
        
        error = Observable.of(nil)
        
        processing = Observable<Bool>
            .merge( filteredSearchText.map { _ in true }, data.map { _ in false }, error.map { _ in false} )
        
        isEmptyState = data.map { $0.isEmpty }
    }
    
}
