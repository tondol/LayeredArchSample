//
//  NewsStore.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/01.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import Foundation
import RxSwift

class InfrastructureError: Error {}

protocol NewsStore {
    func fetchNews(id: Int) -> Single<News>
    func fetchNewsList() -> Single<[News]>
    func createLike(id: Int) -> Single<News>
    func deleteLike(id: Int) -> Single<News>
}
