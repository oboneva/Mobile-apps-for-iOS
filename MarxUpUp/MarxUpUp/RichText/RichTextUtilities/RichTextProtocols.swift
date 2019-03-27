//
//  Protocols.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 19.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import Foundation

protocol RichTextModifying {
    func modifyText(inRange range: NSRange, withNewStyle style: StyleType,
                    andNewValue value: Any)
}

protocol StyleParsing {
    func styleItemsFromXML(_ text: String) -> [StyleItem]
    func XMLForStyleItems(_ styleItems: [StyleItem]) -> String
}
