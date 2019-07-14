//
//  Movie.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    
    let originalTitle: String
    private let posterPath: String?
    
    var imageURL: URL? {
        guard let imagePath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(imagePath)")
    }
}
