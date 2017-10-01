//
//  NewsListPresenterSpec.swift
//  LayeredArchSampleTests
//
//  Created by Tomoyuki Hosaka on 2017/10/02.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest
import RxBlocking

@testable import LayeredArchSample

class NewsListPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: NewsListPresenter!
        var bag: DisposeBag!
        
        beforeEach {
            let store = NewsStoreMock()
            let useCase = NewsUseCaseImpl(store: store)
            presenter = NewsListPresenter(useCase: useCase)
            bag = DisposeBag()
        }
        
        describe("setupUI") {
            it("正常時") {
                presenter.setupUI()
                    .subscribe()
                    .disposed(by: bag)
                let newsList = try! presenter.newsList.asObservable().toBlocking().first()
                
                // setupUI の完了後は News が 3 個表示されており、先頭の News は id=1
                expect(newsList).to(haveCount(3))
                expect(newsList?[0].id) == 1
            }
        }
        
        describe("selectNews") {
            it("正常時") {
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Int.self)
                
                presenter.showDetailViewControllerMessage
                    .subscribe(observer)
                    .disposed(by: bag)
                presenter.setupUI()
                    .subscribe()
                    .disposed(by: bag)
                presenter.selectNews(indexPath: IndexPath(row: 0, section: 0))
                
                // selectNews に先頭の IndexPath を渡すと、id=1 の News を詳細表示
                expect(observer.events).to(haveCount(1))
                expect(observer.events[0].value) == Event.next(1)
            }
        }
    }
}
