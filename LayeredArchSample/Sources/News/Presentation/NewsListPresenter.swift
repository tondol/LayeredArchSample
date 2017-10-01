//
//  NewsListPresenter.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/02.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import Foundation
import RxSwift

class NewsListPresenter: NSObject {
    let newsList = Variable([News]())
    let showDetailViewControllerMessage = PublishSubject<Int>()
    
    private let useCase: NewsUseCase
    private let bag = DisposeBag()
    
    init(useCase: NewsUseCase) {
        self.useCase = useCase
    }
    
    // 初回ロード
    func setupUI() -> Single<Void> {
        let newsList = self.useCase.fetchNewsList()
        newsList
            .subscribe(onSuccess: { [unowned self] newsList -> Void in
                self.newsList.value = newsList
            })
            .disposed(by: self.bag)
        return newsList.map { _ in () }
    }
    
    // cell をタップしたとき
    func selectNews(indexPath: IndexPath) {
        let news = self.newsList.value[indexPath.row]
        self.showDetailViewControllerMessage.onNext(news.id)
    }
    
    // detail 側で更新されたとき
    func updateNews(newValue: News) {
        self.newsList.value = self.newsList.value
            .map { oldValue -> News in
                if oldValue.id == newValue.id {
                    return newValue
                } else {
                    return oldValue
                }
            }
    }
    
    // cell の like ボタンをタップしたとき
    func toggleNews(indexPath: IndexPath) {
        let oldValue = self.newsList.value[indexPath.row]
        var newValue = oldValue
        newValue.liked = !oldValue.liked
        self.updateNews(newValue: newValue)
    }
}

extension NewsListPresenter: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.newsList.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath)
        if let cell = cell as? NewsCell {
            cell.setUI(news: news) { [unowned self] () -> Void in
                self.toggleNews(indexPath: indexPath)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
