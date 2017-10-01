//
//  NewsStoreMock.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/01.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import Foundation
import RxSwift

// 一旦モック版だけ・・・
struct NewsStoreMock: NewsStore {
    let newsList = [
        News(id: 1, title: "title#1", body: "quick brown fox jumped over the lazy dog #1", liked: false),
        News(id: 2, title: "title#2", body: "quick brown fox jumped over the lazy dog #2", liked: false),
        News(id: 3, title: "title#3", body: "quick brown fox jumped over the lazy dog #3", liked: false)
    ]
    
    func fetchNews(id: Int) -> Single<News> {
        if let news = self.newsList.first(where: { $0.id == id }) {
            return Single.just(news)
        } else {
            return Single.error(InfrastructureError())
        }
    }
    
    func fetchNewsList() -> Single<[News]> {
        return Single.just(self.newsList)
    }
    
    func createLike(id: Int) -> Single<News> {
        return self.fetchNews(id: id)
            .map { news -> News in
                var news = news
                news.liked = true
                return news
            }
    }
    
    func deleteLike(id: Int) -> Single<News> {
        return self.fetchNews(id: id)
            .map { news -> News in
                var news = news
                news.liked = false
                return news
            }
    }
}
