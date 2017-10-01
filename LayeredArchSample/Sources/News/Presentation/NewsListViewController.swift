//
//  NewsListViewController.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/01.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListViewController: UIViewController, StoryboardInstantiatable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let bag = DisposeBag()
    private var presenter: NewsListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let store = NewsStoreMock()
        let useCase = NewsUseCaseImpl(store: store)
        self.presenter = NewsListPresenter(useCase: useCase)
        
        self.setupUI()
        self.setupBindings()
        
        self.presenter.setupUI()
            .subscribe()
            .addDisposableTo(self.bag)
    }
    
    private func setupUI() {
        self.tableView.dataSource = self.presenter
        self.tableView.delegate = self
    }
    
    private func setupBindings() {
        self.presenter.newsList
            .asDriver()
            .drive(onNext: { [unowned self] _ -> Void in
                self.tableView.reloadData()
            })
            .disposed(by: self.bag)
        self.presenter.showDetailViewControllerMessage
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [unowned self] id -> Void in
                self.showDetailViewController(id: id)
            })
            .disposed(by: self.bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showDetailViewController(id: Int) {
        let vc = NewsDetailViewController.instantiate(from: "Main")
        vc.id = id
        vc.updateNewsMessage
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [unowned self] news -> Void in
                self.presenter.updateNews(newValue: news)
            })
            .disposed(by: self.bag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.presenter.selectNews(indexPath: indexPath)
    }
}
