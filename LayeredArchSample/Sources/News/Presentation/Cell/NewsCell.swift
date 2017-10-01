//
//  NewsCell.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/02.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    private var bag = DisposeBag()
    
    func setUI(news: News, tapHandler: @escaping () -> Void) {
        self.titleLabel.text = news.title
        self.likeButton.isSelected = news.liked
        
        self.bag = DisposeBag()
        self.likeButton.rx.tap
            .asDriver()
            .drive(onNext: { _ -> Void in
                tapHandler()
            })
            .disposed(by: self.bag)
    }
}
