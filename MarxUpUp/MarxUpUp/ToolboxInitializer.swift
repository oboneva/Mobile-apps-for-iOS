//
//  ToolboxInitializer.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 20.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ToolboxInitializer: NSObject {

    static var buttonSize: Int {
        return 50
    }
    
    static func addToolboxItems(toView scrollView: UIStackView?, withTarget targetController: ToolboxStackController, _ selector: Selector, andDataSource dataSource: ToolboxDataSource) {
        guard let view = scrollView else {
            print("Error: Source view is nil")
            return
        }
        
        let _ = Array(0..<dataSource.itemsCount).map {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
            
            button.tag = $0
            button.setImage(dataSource.item(atIndex: $0).image, for: UIControl.State.normal)
            button.addTarget(targetController, action: selector, for: UIControl.Event.touchDown)
            
            view.addArrangedSubview(button)
        }
        
        view.superview?.layer.cornerRadius = 10
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
}
