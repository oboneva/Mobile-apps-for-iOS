//
//  TabModel.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 16.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class TabModel: NSObject {

    let title: String
    let filter: DataFilter
    
    init(title: String, filter: DataFilter) {
        self.title = title
        self.filter = filter
        super.init()
    }
}
