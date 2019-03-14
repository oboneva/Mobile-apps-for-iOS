//
//  Stylist.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import Foundation

class Stylist: NSObject {
    static func styleText(_ text: String, withStyleItems styles: [StyleItem]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString.init(string: text)

        styles
            .filter { $0.range.length > 0 }
            .forEach { attributedText.addAttributes([$0.name: $0.value], range: $0.range) }

        return attributedText
    }
}
