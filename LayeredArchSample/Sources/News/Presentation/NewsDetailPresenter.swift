//
//  NewsDetailPresenter.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/02.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import Foundation
import RxSwift

class NewsDetailPresenter {
    let news = Variable<News?>(nil)
    let title = Variable<String?>("")
    let body = Variable<String?>("")
    let liked = Variable<Bool>(false)
    
    private let useCase: NewsUseCase
    private let bag = DisposeBag()
    
    init(useCase: NewsUseCase) {
        self.useCase = useCase
    }
    
    func setupUI(id: Int) -> Single<Void> {
        self.news.asObservable()
            .subscribe(onNext: { news -> Void in
                self.title.value = news?.title
                self.body.value = news?.body
                self.liked.value = news?.liked ?? false
            })
            .disposed(by: self.bag)
        
        let news = self.useCase.fetchNews(id: id)
        news
            .subscribe(onSuccess: { [unowned self] news -> Void in
                self.news.value = news
            })
            .disposed(by: self.bag)
        return news.map { _ in () }
    }
    
    func toggleLike(id: Int) -> Single<Void> {
        let oldValue = self.news.value?.liked ?? false
        let newValue = !oldValue
        
        if newValue {
            let newNews = self.useCase.createLike(id: id)
            newNews
                .subscribe(onSuccess: { [unowned self] news -> Void in
                    self.news.value = news
                })
                .disposed(by: self.bag)
            return newNews.map { _ in () }
        } else {
            let newNews = self.useCase.deleteLike(id: id)
            newNews
                .subscribe(onSuccess: { [unowned self] news -> Void in
                    self.news.value = news
                })
                .disposed(by: self.bag)
            return newNews.map { _ in () }
        }
    }
}
