//
//  File.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import Foundation
import RxSwift

struct CustomErrors: Error {
    
    static let genericError = NSError(domain: "Generic", code: 0)
    static let noDataError = NSError(domain: "No data", code: 1)
    static let noResultsError = NSError(domain: "No results", code: 2)
    static let exceptionError = NSError(domain: "Exception", code: 3)
}

class DataManager {

    static let shared = DataManager()
    
    private init() { }
    
    private func getMoviesUrlSearchForMovieName(movieName: String) -> URL? {
        let movieNameS = movieName.replacingOccurrences(of: " ", with: "%20")
        return URL(string: "https://api.themoviedb.org/3/search/movie?api_key=f0e3c4fcec46612abd4acf735d09c4a6&query=" + (movieNameS) + "&sort_by=original_title.asc")
    }
    
    func getMovies(with title: String) -> Observable<[Movie]> {
        
        return Observable<[Movie]>.create { observer in
            
            guard let url = DataManager.shared.getMoviesUrlSearchForMovieName(movieName: title) else {
                
                observer.onError(CustomErrors.genericError)
                return Disposables.create()
            }
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, _, opError in
                
                if let error = opError {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(CustomErrors.noDataError)
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    guard
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let results = json["results"] as? [[String: Any]]
                    else {
                        observer.onError(CustomErrors.noResultsError)
                        return
                    }
                    
                    let newData = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                    
                    let movies = try jsonDecoder.decode([Movie].self, from: newData)
                    
                    observer.onNext(movies)
                    observer.onCompleted()
                    
                } catch {
                    
                    observer.onError(CustomErrors.exceptionError)
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
    
    
}
