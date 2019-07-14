//
//  MoviePosterViewController.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import UIKit

class MoviePosterViewController: UIViewController {

    @IBOutlet private weak var movieImageView: UIImageView!
    
    let viewModel: MoviePosterViewModel
    
    init(viewModel: MoviePosterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "\(MoviePosterViewController.self)", bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
