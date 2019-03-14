//
//  StyleModels.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import Foundation

class StyleItem {
    let name: NSAttributedString.Key
    let value: Any
    var range = NSRange()

    init(_ name: StyleType, _ value: Any) {
        self.name = name.attributedStringKey
        self.value = value
    }
}

extension StyleItem: Equatable {
    ///// cannot compare items' values
    static func == (left: StyleItem, right: StyleItem) -> Bool {
        return left.name == right.name && left.name == right.name
    }
}

class CustomStyle: NSObject {
    var name = ""
    var styleItems = [StyleItem]()
}
