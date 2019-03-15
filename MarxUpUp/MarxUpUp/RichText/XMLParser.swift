//
//  XMLParser.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 12.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import UIKit

class Parser: NSObject {

    private var styleItems = [StyleItem]()
    private var customStyleItems = [CustomStyle]()
    private var foundCharacters = ""
    private(set) var extractedText = ""
    private var currentStringLength = 0

    private var customStyleItemsNames: [String] {
        return customStyleItems.map { $0.name }
    }

    func parseText(_ text: String) -> [StyleItem] {
        let xmlData = text.data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()

        return styleItems
    }

    func parsePredefinedStyleElement(fromType type: StyleType, andAttributeDict dict: [String: String]) {
        guard let value = dict[XMLElement.value.rawValue] else {
            return
        }

        if type.isColor {
            let color = UIColor.init(fromHEX: value)
            styleItems.append(StyleItem(type, color))
        } else if type.isLine {
            let line = LineStyle(rawValue: value)?.key
            styleItems.append(StyleItem(type, line as Any))
        } else if type == StyleType.link {
            let link = NSString(string: value)
            styleItems.append(StyleItem(type, link))
        } else if type == StyleType.strokeWidth {
            let width = NumberFormatter().number(from: value)
            styleItems.append(StyleItem(type, width as Any))
        }
    }

    func shadowStyleElement(fromAttributeDict dict: [String: String]) -> StyleItem {
        let shadow = NSShadow.init()

        if let colorString = dict[XMLElement.color.rawValue] {
            shadow.shadowColor = UIColor(fromHEX: colorString)
        }

        if let offsetHString = dict[XMLElement.offsetHeight.rawValue],
            let offsetH = NumberFormatter().number(from: offsetHString)?.floatValue,
            let offsetWString = dict[XMLElement.offsetWidth.rawValue],
            let offsetW = NumberFormatter().number(from: offsetWString)?.floatValue {
            shadow.shadowOffset = CGSize(width: CGFloat(offsetW), height: CGFloat(offsetH))
        }

        if let blurString = dict[XMLElement.blur.rawValue],
            let blur = NumberFormatter().number(from: blurString)?.floatValue {
            shadow.shadowBlurRadius = CGFloat(blur)
        }

        return StyleItem(.shadow, shadow)
    }

    func fontStyleElement(fromAttributeDict dict: [String: String]) -> StyleItem {
        if let fontName = dict[XMLElement.name.rawValue],
            let sizeString = dict[XMLElement.size.rawValue],
            let size = NumberFormatter().number(from: sizeString)?.floatValue {
            return StyleItem(.font, UIFont(name: fontName, size: CGFloat(size)) as Any)
        }

        return StyleItem(.font, UIFont.systemFont(ofSize: UIFont.systemFontSize) as Any)
    }

    func parsePredefinedStyleElementShadow(withAttributeDict dict: [String: String]) {
        let shadow = shadowStyleElement(fromAttributeDict: dict)
        styleItems.append(shadow)
    }

    func parsePredefinedStyleElementFont(withAttributeDict dict: [String: String]) {
        let font = fontStyleElement(fromAttributeDict: dict)
        styleItems.append(font)
    }

    func filterAttributes(_ attributeDict: [String: String], forStyleType type: StyleType) -> [String: String] {
        return Dictionary(uniqueKeysWithValues: attributeDict
            .filter { (key, _) -> Bool in
                key.contains(type.rawValue) }
            .map { (arg) -> (String, String) in
                let (_, _) = arg
                return (String(arg.key.dropFirst(type.rawValue.count)).firstLowercased,
                        arg.value) })
    }

    func isColorElement(_ element: String) -> Bool {
        return element == StyleType.backgroundColor.rawValue ||
                element == StyleType.foregroundColor.rawValue ||
                element == StyleType.underlineColor.rawValue ||
                element == StyleType.strikethroughColor.rawValue ||
                element == StyleType.strokeColor.rawValue
    }
}

extension Parser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        if elementName == XMLElement.style.rawValue {
            let styleTag = CustomStyle()

            if let foregroundColor = attributeDict[StyleType.foregroundColor.rawValue] {
                let color = UIColor.init(fromHEX: foregroundColor)
                let styleItem = StyleItem.init(.foregroundColor, color)
                styleTag.styleItems.append(styleItem)
            }

            if let backgroundColor = attributeDict[StyleType.backgroundColor.rawValue] {
                let color = UIColor.init(fromHEX: backgroundColor)
                let styleItem = StyleItem.init(.backgroundColor, color)
                styleTag.styleItems.append(styleItem)
            }

            if let underlineColor = attributeDict[StyleType.underlineColor.rawValue] {
                let color = UIColor(fromHEX: underlineColor)
                let styleItem = StyleItem(.underlineColor, color)
                styleTag.styleItems.append(styleItem)
            }

            if let strikethroughColor = attributeDict[StyleType.strikethroughColor.rawValue] {
                let color = UIColor(fromHEX: strikethroughColor)
                let styleItem = StyleItem(.strikethroughColor, color)
                styleTag.styleItems.append(styleItem)
            }

            if let strokeColor = attributeDict[StyleType.strokeColor.rawValue] {
                let color = UIColor(fromHEX: strokeColor)
                let styleItem = StyleItem(.strokeColor, color)
                styleTag.styleItems.append(styleItem)
            }

            if let underlineStyle = attributeDict[StyleType.underlineStyle.rawValue],
                let lineStyle = LineStyle(rawValue: underlineStyle)?.key {
                let styleItem = StyleItem(.underlineStyle, lineStyle as NSUnderlineStyle)
                styleTag.styleItems.append(styleItem)
            }

            if let strikethroughStyle = attributeDict[StyleType.strikethroughStyle.rawValue],
                let lineStyle = LineStyle(rawValue: strikethroughStyle)?.key {
                let styleItem = StyleItem(.strikethroughStyle, lineStyle as NSUnderlineStyle)
                styleTag.styleItems.append(styleItem)
            }

            if let link = attributeDict[StyleType.link.rawValue] {
                let styleItem = StyleItem(.link, NSString(string: link))
                styleTag.styleItems.append(styleItem)
            }

            if let name = attributeDict[XMLElement.name.rawValue] {
                styleTag.name = name
            }

            if let strokeWidth = attributeDict[StyleType.strokeWidth.rawValue],
                let width = NumberFormatter().number(from: strokeWidth) {
                styleTag.styleItems.append(StyleItem(.strokeWidth, width))
            }

            let shadowAttributes = filterAttributes(attributeDict, forStyleType: .shadow)
            if shadowAttributes.count > 0 {
                let shadow = shadowStyleElement(fromAttributeDict: shadowAttributes)
                styleTag.styleItems.append(shadow)
            }

            let fontAttributes = filterAttributes(attributeDict, forStyleType: .font)
            if fontAttributes.count > 0 {
                let font = fontStyleElement(fromAttributeDict: fontAttributes)
                styleTag.styleItems.append(font)
            }

            customStyleItems.append(styleTag)
        }

        guard let type = StyleType(rawValue: elementName) else {
            return
        }

        if type.isAtomic {
            parsePredefinedStyleElement(fromType: type, andAttributeDict: attributeDict)
        } else if type == .shadow {
            parsePredefinedStyleElementShadow(withAttributeDict: attributeDict)
        } else if type == .font {
            parsePredefinedStyleElementFont(withAttributeDict: attributeDict)
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {

        if StyleType(rawValue: elementName) != nil {
            styleItems.last { (item) -> Bool in
                item.name == StyleType(rawValue: elementName)!.attributedStringKey && item.range.length == 0
                }?.range = NSRange(location: extractedText.count - currentStringLength, length: currentStringLength)
        } else if elementName == XMLElement.string.rawValue {
            extractedText += foundCharacters
            currentStringLength = foundCharacters.count
        } else if customStyleItemsNames.contains(elementName) {
            let styleItems3 = customStyleItems.filter { (custom) -> Bool in
                custom.name == elementName
            }
            if let last = styleItems3.last?.styleItems {
                last.filter { (item) -> Bool in
                    item.range.length == 0
                    }.forEach { (item) in
                        item.range = NSRange(location: extractedText.count - currentStringLength,
                                             length: currentStringLength)
                }
                styleItems.append(contentsOf: last)
            }
        }

        foundCharacters = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        styleItems = []
    }
}
