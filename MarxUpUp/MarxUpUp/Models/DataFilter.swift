//
//  DataFilter.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 15.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class DataFilter: NSObject {

    let isDataLocal: Bool
    let sort: ImageSort

    init(local: Bool, sort: ImageSort) {
        isDataLocal = local
        self.sort = sort
        super.init()
    }
}
