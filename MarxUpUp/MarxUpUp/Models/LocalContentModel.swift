//
//  LocalContentModel.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 2.01.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import UIKit

class LocalContentModel: NSObject {

    var data: Data
    let id: URL

    init(_ data: Data, _ id: URL) {
        self.data = data
        self.id = id
    }
    
    func update(_ data: Data) {
        self.data = data
    }
    
}
