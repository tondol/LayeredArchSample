//
//  UIViewController+Instantiable.swift
//  LayeredArchSample
//
//  Created by Tomoyuki Hosaka on 2017/10/02.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import UIKit

// reference: https://blog.sgr-ksmt.org/2017/01/17/vc_and_storyboard/
protocol StoryboardInstantiatable {}

extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate(from storyboardName: String) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
