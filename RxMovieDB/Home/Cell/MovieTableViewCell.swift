//
//  MovieTableViewCell.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var posterButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    private let buttonPressed = PublishSubject<Void>()
    var publicButtonPressed: Observable<Void> {
        return buttonPressed.asObservable()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func configure(with movieTitle: String) {
        
        self.titleLabel.text = movieTitle
        
        self.posterButton.rx
            .tap
            .bind(to: self.buttonPressed)
            .disposed(by: self.disposeBag)
    }
}
