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

    // MARK: - Parsing from XML custom style elements
    private func colorStyleElementsFromAttributedDict(_ dict: [String: String],
                                                      withRange range: NSRange) -> [StyleItem] {
        return StyleType.colorElements()
            .map { (colorElement) -> StyleItem? in
                guard let colorHEX = dict[colorElement.rawValue] else {
                    return nil
                }
                return StyleItem(colorElement, UIColor.init(fromHEX: colorHEX), range)}
            .compactMap { $0 }
    }

    private func lineStyleElementsFromAttributedDict(_ dict: [String: String],
                                                     withRange range: NSRange) -> [StyleItem] {
        return StyleType.lineElements()
            .map { (lineElement) -> StyleItem? in
                guard let lineString = dict[lineElement.rawValue],
                    let lineStyle = LineStyle(rawValue: lineString)?.key else {
                        return nil
                }
                return StyleItem(lineElement, lineStyle as NSUnderlineStyle, range)}
            .compactMap { $0 }
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

    private func parseCustomStyleElement(withAttributedDict dict: [String: String], andRange range: NSRange) {
        let colorStyleElements = colorStyleElementsFromAttributedDict(dict, withRange: range)
        styleItems.append(contentsOf: colorStyleElements)

        let lineStyleElements = lineStyleElementsFromAttributedDict(dict, withRange: range)
        styleItems.append(contentsOf: lineStyleElements)

        if let link = dict[StyleType.link.rawValue] {
            styleItems.append(StyleItem(.link, NSString(string: link), range))
        }

        if let strokeWidth = CGFloat(fromDict: dict, forKey: StyleType.strokeWidth.rawValue) {
            styleItems.append(StyleItem(.strokeWidth, strokeWidth, range))
        }

        let shadowAttributes = filterAttributes(dict, forStyleType: .shadow)
        if !shadowAttributes.isEmpty {
            styleItems.append(StyleItem(shadowFromDict: shadowAttributes, withRange: range))
        }

        let fontAttributes = filterAttributes(dict, forStyleType: .font)
        if !fontAttributes.isEmpty {
            styleItems.append(StyleItem(fontFromDict: fontAttributes, withRange: range))
        }

    }

    // MARK: - Parsing from XML predefined style elements
    private func parsePredefinedStyleElement(fromType type: StyleType,
                                             withAttributedDict dict: [String: String],
                                             andRange range: NSRange) {
        if type.isAtomic {
            parseAtomicPredefinedStyleElement(fromType: type, withAttributeDict: dict, andRange: range)
        } else if type == .shadow {
            styleItems.append(StyleItem(shadowFromDict: dict, withRange: range))
        } else if type == .font {
            styleItems.append(StyleItem(fontFromDict: dict, withRange: range))
        }
    }

    private func parseAtomicPredefinedStyleElement(fromType type: StyleType,
                                                   withAttributeDict dict: [String: String],
                                                   andRange range: NSRange) {
        guard let value = dict[XMLElement.value.rawValue] else {
            return
        }

        if type.isColor {
            let color = UIColor.init(fromHEX: value)
            styleItems.append(StyleItem(type, color, range))
        } else if type.isLine {
            let line = LineStyle(rawValue: value)?.key
            styleItems.append(StyleItem(type, line as Any, range))
        } else if type == StyleType.link {
            let link = NSString(string: value)
            styleItems.append(StyleItem(type, link, range))
        } else if type == StyleType.strokeWidth {
            let width = NumberFormatter().number(from: value)
            styleItems.append(StyleItem(type, width as Any, range))
        }
    }

    // MARK: - to XML methods
    func customStyleItem(withItems items: [StyleItem]) -> String {
        let attributes = xmlTagAttributes(forCustomStyleWithItems: items)
        let internalAttributes = attributes.joined(separator: " ")
        return "<\(XMLElement.style) \(internalAttributes) range=\"\(items.first!.range.stringValue)\"/>"
    }

    func xmlTagAttributes(forCustomStyleWithItems items: [StyleItem]) -> [String] {
        return items.map { (item: StyleItem) -> String in
            if item.type.isAtomic {
                return "\(item.type)=\"\(item.valueAsString)\""
            }

            return xmlTagAttributesForNonAtomicTag(item).joined(separator: " ")
        }
    }

    func xmlElement(fromStyleItem item: StyleItem) -> String {
        let internalAttributes = xmlTagAttributes(forStyleItem: item).joined(separator: " ")
        return "<\(item.type.rawValue) \(internalAttributes)/>"
    }

    func xmlTagAttributes(forStyleItem item: StyleItem) -> [String] {
        if item.type.isAtomic {
            return ["\(XMLElement.value)=\"\(item.valueAsString)\"",
                "\(XMLElement.range)=\"\(item.range.stringValue)\""]
        }
        return xmlTagAttributesForNonAtomicTag(item)
    }

    func xmlTagAttributesForNonAtomicTag(_ styleItem: StyleItem) -> [String] {
        var attributes = [String]()
        //fix this!!!!!!!!!!!!
        if styleItem.type == .font {
            let font = styleItem.value as! UIFont
            let name = font.fontName
            let size: CGFloat = font.pointSize

            attributes = ["\(XMLElement.name)=\"\(name)\"",
                "\(XMLElement.size)=\"\(size.stringValue)\"",
                "\(XMLElement.range)=\"\(styleItem.range.stringValue)\""]
            return attributes
        } else if styleItem.type == .shadow {
            let shadow = styleItem.value as! NSShadow
            let color = shadow.shadowColor as! UIColor
            let blur = shadow.shadowBlurRadius
            let offset = shadow.shadowOffset

            attributes = ["\(XMLElement.color)=\"\(color.hex)\"",
                "\(XMLElement.blur)=\"\(blur.stringValue)\"",
                "\(XMLElement.offsetHeight)=\"\(offset.height.stringValue)\"",
                "\(XMLElement.offsetWidth)=\"\(offset.width.stringValue)\"",
                "\(XMLElement.range)=\"\(styleItem.range.stringValue)\""]
        }

        return attributes
    }
}

// MARK: - XMLParserDelegate methods
extension Parser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        guard let rangeString = attributeDict[XMLElement.range.rawValue],
            let range = NSRange.init(fromString: rangeString) else { return }

        if elementName == XMLElement.style.rawValue {
            parseCustomStyleElement(withAttributedDict: attributeDict, andRange: range)
        }

        guard let type = StyleType(rawValue: elementName) else { return }
        parsePredefinedStyleElement(fromType: type, withAttributedDict: attributeDict, andRange: range)
    }
}

// MARK: - StyleParsing methods
extension Parser: StyleParsing {
    func styleItemsFromXML(_ text: String) -> [StyleItem] {
        let xmlData = "<m>\(text)</m>".data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()

        return styleItems
    }

    func XMLForStyleItems(_ styleItems: [StyleItem]) -> String {
        let groupedItems = Dictionary(grouping: styleItems) { $0.range }

        return groupedItems.map { (_, itemsWithTheSameRange) -> String in
            if itemsWithTheSameRange.count > 1 {
                return customStyleItem(withItems: itemsWithTheSameRange)
            }
            return xmlElement(fromStyleItem: itemsWithTheSameRange.first!)
        }.joined(separator: "")
    }
}
