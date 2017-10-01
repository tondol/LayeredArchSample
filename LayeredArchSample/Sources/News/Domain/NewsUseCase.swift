//
//  NewsUseCase.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/01.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import Foundation
import RxSwift

protocol NewsUseCase {
    func fetchNews(id: Int) -> Single<News>
    func fetchNewsList() -> Single<[News]>
    func createLike(id: Int) -> Single<News>
    func deleteLike(id: Int) -> Single<News>
}

class NewsUseCaseImpl: NewsUseCase {
    let store: NewsStore
    
    init(store: NewsStore) {
        self.store = store
    }
    
    func fetchNews(id: Int) -> Single<News> {
        return store.fetchNews(id: id)
    }
    
    func fetchNewsList() -> Single<[News]> {
        return store.fetchNewsList()
    }
    
    func createLike(id: Int) -> Single<News> {
        return store.createLike(id: id)
    }
    
    func deleteLike(id: Int) -> Single<News> {
        return store.deleteLike(id: id)
    }
}
