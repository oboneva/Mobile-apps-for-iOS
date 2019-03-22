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

    private var styleRange: NSRange {
        return NSRange(location: extractedText.count - currentStringLength, length: currentStringLength)
    }

    private func colorStyleElementsFromAttributedDict(_ dict: [String: String]) -> [StyleItem] {
        return StyleType.colorElements()
            .map { (colorElement) -> StyleItem? in
                guard let colorHEX = dict[colorElement.rawValue] else {
                    return nil
                }
                return StyleItem(colorElement, UIColor.init(fromHEX: colorHEX))}
            .compactMap { $0 }
    }

    private func lineStyleElementsFromAttributedDict(_ dict: [String: String]) -> [StyleItem] {
        return StyleType.lineElements()
            .map { (lineElement) -> StyleItem? in
                guard let lineString = dict[lineElement.rawValue],
                    let lineStyle = LineStyle(rawValue: lineString)?.key else {
                        return nil
                }
                return StyleItem(lineElement, lineStyle as NSUnderlineStyle)}
            .compactMap { $0 }
    }

    private func parsePredefinedStyleElement(fromType type: StyleType, andAttributeDict dict: [String: String]) {
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

    private func filterAttributes(_ attributeDict: [String: String], forStyleType type: StyleType) -> [String: String] {
        return Dictionary(uniqueKeysWithValues: attributeDict
            .filter { (key, _) -> Bool in
                key.contains(type.rawValue) }
            .map { (arg) -> (String, String) in
                let (_, _) = arg
                return (String(arg.key.dropFirst(type.rawValue.count)).firstLowercased,
                        arg.value) })
    }

    private func parseCustomStyleElement(withAttributedDict dict: [String: String]) {
        let styleTag = CustomStyle()

        let colorStyleElements = colorStyleElementsFromAttributedDict(dict)
        styleTag.styleItems.append(contentsOf: colorStyleElements)

        let lineStyleElements = lineStyleElementsFromAttributedDict(dict)
        styleTag.styleItems.append(contentsOf: lineStyleElements)

        if let link = dict[StyleType.link.rawValue] {
            let styleItem = StyleItem(.link, NSString(string: link))
            styleTag.styleItems.append(styleItem)
        }

        if let name = dict[XMLElement.name.rawValue] {
            styleTag.name = name
        }

        if let strokeWidth = CGFloat(fromDict: dict, forKey: StyleType.strokeWidth.rawValue) {
            styleTag.styleItems.append(StyleItem(.strokeWidth, strokeWidth))
        }

        let shadowAttributes = filterAttributes(dict, forStyleType: .shadow)
        if shadowAttributes.count > 0 {
            styleTag.styleItems.append(StyleItem(shadowFromDict: shadowAttributes))
        }

        let fontAttributes = filterAttributes(dict, forStyleType: .font)
        if fontAttributes.count > 0 {
            styleTag.styleItems.append(StyleItem(fontFromDict: fontAttributes))
        }

        customStyleItems.append(styleTag)
    }

    private func parsePredefinedStyleElement(fromType type: StyleType, withAttributedDict dict: [String: String]) {
        if type.isAtomic {
            parsePredefinedStyleElement(fromType: type, andAttributeDict: dict)
        } else if type == .shadow {
            styleItems.append(StyleItem(shadowFromDict: dict))
        } else if type == .font {
            styleItems.append(StyleItem(fontFromDict: dict))
        }
    }
}

// MARK: - XMLParserDelegate methods
extension Parser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        if elementName == XMLElement.style.rawValue {
            parseCustomStyleElement(withAttributedDict: attributeDict)
        }

        guard let type = StyleType(rawValue: elementName) else { return }
        parsePredefinedStyleElement(fromType: type, withAttributedDict: attributeDict)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {

        if StyleType(rawValue: elementName) != nil {
            styleItems.last { (item) -> Bool in
                item.type == StyleType(rawValue: elementName) && item.range.length == 0
                }?.range = styleRange
        } else if elementName == XMLElement.string.rawValue {
            extractedText += foundCharacters
            currentStringLength = foundCharacters.count
        } else if customStyleItemsNames.contains(elementName) {
            let currentCustomStyleElement = customStyleItems.last {
                $0.name == elementName && $0.styleItems.first?.range.length == 0 }
            currentCustomStyleElement?.styleItems.forEach { $0.range = styleRange }
            styleItems.append(contentsOf: currentCustomStyleElement?.styleItems ?? [])
        }

        foundCharacters = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        styleItems = []
    }

    func stringElement(withText text: String) -> String {
        return "<\(XMLElement.string.rawValue)>\(text)</\(XMLElement.string.rawValue)>"
    }

    func xmlElement(fromStyleItem item: StyleItem, text: String) -> String {
        }
    }
}

// MARK: - StyleParsing methods
extension Parser: StyleParsing {
    func styleItemsFromXML(_ text: String) -> [StyleItem] {
        let xmlData = text.data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()

        return styleItems
    }

    func XMLForStyleItems(_ styleItems: [StyleItem], andText text: String) -> String {
        let item = styleItems[0]
        let string = stringElement(withText: text)

        return xmlElement(fromStyleItem: item, text: string)
    }
}
