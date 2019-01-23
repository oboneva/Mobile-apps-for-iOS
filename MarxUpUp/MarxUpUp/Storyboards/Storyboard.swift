//
//  Storyboard.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    
    case Main = "Main"
    case Annotate = "Annotate"
    case ToolboxItem = "ToolboxItem"
    
    var instance: UIStoryboard {
        return  UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(fromClass viewControllerClass: T.Type) -> T {
        let id = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: id) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)" + "ID"
    }
    
    static func instantiateFromStoryboard(storyborad: Storyboard) -> UIViewController {
        return storyborad.viewController(fromClass: self)
    }
}
