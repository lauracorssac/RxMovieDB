//
//  MoviePosterViewModel.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import Foundation
import RxSwift

class MoviePosterViewModel {
    
    let moviePosterURL: URL?
    let placeHolderImage = UIImage(named: "sorry")
    
    init(movie: Movie) {
        
        moviePosterURL = movie.imageURL
        
    }
    
}
