//
//  HomeViewController.swift
//  RxMovieDB
//
//  Created by Laura Corssac on 13/07/19.
//  Copyright © 2019 Laura Corssac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var moviesTableView: UITableView!
    @IBOutlet private weak var movieTextField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "movieCell"
    
    private let viewModel = HomeViewModel()
    
    init() {
        super.init(nibName: "\(HomeViewController.self)", bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTableView.register(UINib(nibName: "\(MovieTableViewCell.self)", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let searchObservable = movieTextField.rx.text
            .debug("search observable", trimOutput: false)
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        searchObservable
            .bind(to: self.viewModel.searchText)
            .disposed(by: self.disposeBag)
        
        viewModel.data
            .debug("view model data", trimOutput: false)
            .bind(to: moviesTableView.rx.items(cellIdentifier: cellIdentifier, cellType: MovieTableViewCell.self)) { _, movie, cell in
                
                cell.configure(with: movie.originalTitle)
                
                cell.publicButtonPressed
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { _ in
                        
                        let vc = MoviePosterViewController(viewModel: MoviePosterViewModel(movie: movie))
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }).disposed(by: cell.disposeBag) // cell disposeBag !!!
                
                
            }.disposed(by: self.disposeBag)
        
        viewModel.error
            .debug("view model error", trimOutput: false)
            .map { $0 != nil }
            .observeOn(MainScheduler.instance)
            .bind(to: moviesTableView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        viewModel.error
            .filter { $0 != nil }
            .map { $0! }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                
                    let vc = UIAlertController(title: "Oops, deu erro!", message: "Tente novamente mais tarde", preferredStyle: .alert)
                
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    vc.addAction(action)
                    self?.present(vc, animated: true, completion: nil)
            
            }).disposed(by: self.disposeBag)
        
        viewModel
            .processing
            .debug("view model processing", trimOutput: false)
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        viewModel
            .processing
            .map { !$0 }
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: self.disposeBag)
        
    }


}
