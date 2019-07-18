//
//  HomeViewModel.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import Foundation
import RxSwift

// FINAL VIEWMODEL - DIFFERENTIATES EMPTY STATE FROM ERROR

class HomeViewModel {
    
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
        
        let result =
            filteredSearchText
            .flatMapLatest { text -> Observable<Event<[Movie]>> in
                return DataManager.shared.getMovies(with: text)
                    .debug("data manager get movies", trimOutput: false)
                    .materialize()
            }
            .debug("movie search result", trimOutput: false)
            .observeOn(MainScheduler.instance)
            .share()
        
        data = result
            .filter { $0.element != nil}
            .map {
                $0.element!
            }.share()
        
        error = result
            .map { $0.error }
            .share()
        
        processing = Observable<Bool>
            .merge( filteredSearchText.map { _ in true }, data.map { _ in false }, error.map { _ in false} )
        
        isEmptyState = data.map { $0.isEmpty }
    }
    
}
