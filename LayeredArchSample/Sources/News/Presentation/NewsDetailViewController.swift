//
//  NewsDetailViewController.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/01.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsDetailViewController: UIViewController, StoryboardInstantiatable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var bodyLabel: UILabel!
    
    let updateNewsMessage = PublishSubject<News>()
    var id: Int?
    
    private let bag = DisposeBag()
    private var presenter: NewsDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let store = NewsStoreMock()
        let useCase = NewsUseCaseImpl(store: store)
        self.presenter = NewsDetailPresenter(useCase: useCase)
        
        self.setupUI()
        self.setupBindings()
        
        guard let id = self.id else { return }
        
        self.presenter.setupUI(id: id)
            .subscribe()
            .addDisposableTo(self.bag)
    }
    
    private func setupUI() {
    }
    
    private func setupBindings() {
        self.likeButton.rx.tap
            .asDriver()
            .flatMap { [unowned self] _ -> Driver<Void> in
                guard let id = self.id else { return Driver.empty() }
                
                return self.presenter.toggleLike(id: id)
                    .asDriver(onErrorDriveWith: Driver.empty())
            }
            .drive()
            .disposed(by: self.bag)
        
        self.presenter.title
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: self.bag)
        self.presenter.body
            .asDriver()
            .drive(self.bodyLabel.rx.text)
            .disposed(by: self.bag)
        self.presenter.liked
            .asDriver()
            .drive(self.likeButton.rx.isSelected)
            .disposed(by: self.bag)
        
        self.presenter.news
            .asDriver()
            .drive(onNext: { [unowned self] news -> Void in
                guard let news = news else { return }
                
                self.updateNewsMessage.onNext(news)
            })
            .disposed(by: self.bag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
