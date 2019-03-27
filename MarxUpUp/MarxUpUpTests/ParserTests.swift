//
//  ParserTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 13.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ParserTests: XCTestCase {

    var parser: Parser!

    override func setUp() {
        parser = Parser()
    }

    override func tearDown() {
        parser = nil
    }

    // MARK: - XML to StyleElement objects tests
    func testSinglePredefinedStyleElement() {
        let colorHEX = "#ffffff"
        let text = "<foregroundColor value=\"\(colorHEX)\" range=\"0,0\"/>"

        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.foregroundColor, color, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testTwoPredefinedStyleItems() {
        let firstColorHEX = "#ffffff"
        let secondColorHEX = "#000000"

        let firstColor = UIColor(fromHEX: firstColorHEX)
        let secondColor = UIColor(fromHEX: secondColorHEX)

        let text = "<backgroundColor value=\"\(firstColorHEX)\" range=\"0,0\"/><foregroundColor value=\"\(secondColorHEX)\" range=\"0,0\">"

        let styleItems = parser.styleItemsFromXML(text)

        let expectedStyleItem1 = StyleItem(StyleType.backgroundColor, firstColor, NSRange())
        let expectedStyleItem2 = StyleItem(StyleType.foregroundColor, secondColor, NSRange())
        let expectedStyleItems = [expectedStyleItem1, expectedStyleItem2]

        XCTAssertEqual(styleItems, expectedStyleItems)
    }

    func testSingleCustomStyleItem() {
        let firstColorHEX = "#ffffff"
        let secondColorHEX = "#000000"

        let firstColor = UIColor(fromHEX: firstColorHEX)
        let secondColor = UIColor(fromHEX: secondColorHEX)

        let text = "<style foregroundColor=\"\(firstColorHEX)\" backgroundColor=\"\(secondColorHEX)\" range=\"0,0\"/>"

        let styleItems = parser.styleItemsFromXML(text)

        let expectedStyleItem1 = StyleItem(StyleType.backgroundColor, secondColor, NSRange())
        let expectedStyleItem2 = StyleItem(StyleType.foregroundColor, firstColor, NSRange())
        let expectedStyleItems = [expectedStyleItem1, expectedStyleItem2]

        XCTAssertEqual(styleItems, expectedStyleItems)
    }

    func testUnderlineColor() {
        let colorHEX = "#ffffff"
        let text = "<underlineColor value=\"\(colorHEX)\" range=\"0,0\"/>"
        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.underlineColor, color, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testUnderlineStyle() {
        let underlineStyleKey = "patternDot"
        let text = "<underlineStyle value=\"\(underlineStyleKey)\" range=\"0,0\"/>"
        let underlineStyle = NSUnderlineStyle.patternDot

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.underlineStyle, underlineStyle, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testStriketroughColor() {
        let colorHEX = "#ffffff"
        let text = "<strikethroughColor value=\"\(colorHEX)\" range=\"0,0\"/>"
        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.strikethroughColor, color, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testStrikethroughStyle() {
        let strikethroughStyleKey = "patternDot"
        let text = "<strikethroughStyle value=\"\(strikethroughStyleKey)\" range=\"0,0\"/>"
        let strikethroughStyle = NSUnderlineStyle.patternDot

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.strikethroughStyle, strikethroughStyle, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testLink() {
        let linkValue = "https://www.google.com/"
        let text = "<link value=\"\(linkValue)\" range=\"0,0\"/>"
        let link = NSString(string: linkValue)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.link, link, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testLinkInsideCustomStyle() {
        let linkValue = "https://www.google.com/"
        let text = "<style link=\"\(linkValue)\" range=\"0,0\">"
        let link = NSString(string: linkValue)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.link, link, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testStrokeColor() {
        let colorHEX = "#ffffff"
        let text = "<strokeColor value=\"\(colorHEX)\" range=\"0,0\"/>"
        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.strokeColor, color, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testStrokeColorInsideCustomStyle() {
        let colorHEX = "#ffffff"
        let text = "<style strokeColor=\"\(colorHEX)\" range=\"0,0\">"
        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.strokeColor, color, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testStrokeWidth() {
        let width: CGFloat = 4.1
        let text = "<strokeWidth value=\"\(width)\" range=\"0,0\"/>"

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.strokeWidth, width, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testStrokeWidthInsideCustomStyle() {
        let width: CGFloat = 4.0
        let text = "<style strokeWidth=\"\(width)\" range=\"0,0\">"

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.strokeWidth, width, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testShadow() {
        let colorHEX = "#ffffff"
        let blurRadius: CGFloat = 2.0
        let offsetSize = CGSize(width: 3.0, height: 4.0)

        let text = "<shadow color=\"\(colorHEX)\" blur=\"\(blurRadius)\" offsetHeight=\"\(offsetSize.height)\" offsetWidth=\"\(offsetSize.width)\" range=\"0,0\"/>"

        let color = UIColor(fromHEX: colorHEX)
        let shadow = NSShadow()
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowOffset = offsetSize
        shadow.shadowColor = color

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.shadow, shadow, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testShadowInsideCustomStyle() {
        let colorHEX = "#ffffff"
        let blurRadius: CGFloat = 2.0
        let offsetSize = CGSize(width: 3.0, height: 4.0)

        let text = "<style shadowColor=\"\(colorHEX)\" shadowBlur=\"\(blurRadius)\" shadowOffsetWidth=\"\(offsetSize.width)\" shadowOffsetHeight=\"\(offsetSize.height)\" range=\"0,0\">"

        let color = UIColor(fromHEX: colorHEX)
        let shadow = NSShadow()
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowOffset = offsetSize
        shadow.shadowColor = color

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.shadow, shadow, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testFont() {
        let size: CGFloat = 16.0
        let fontName = "AvenirNext-BoldItalic"
        let text = "<font name=\"\(fontName)\" size=\"\(size)\" range=\"0,0\"/>"
        let font = UIFont(name: fontName, size: size)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.font, font!, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testUndefinedFont() {
        let size: CGFloat = 16.0
        let fontName = "AvenirNext-Boldalic"
        let text = "<font name=\"\(fontName)\" size=\"\(size)\" range=\"0,0\"/>"
        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.font, font, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    func testFontInsideCustomStyle() {
        let size: CGFloat = 16.0
        let fontName = "AvenirNext-BoldItalic"

        let text = "<style fontName=\"\(fontName)\" fontSize=\"\(size)\" range=\"0,0\">"

        let font = UIFont(name: fontName, size: size)

        let styleItems = parser.styleItemsFromXML(text)
        let expectedStyles = [StyleItem(StyleType.font, font!, NSRange())]

        XCTAssertEqual(expectedStyles, styleItems)
    }

    // MARK: - StyleElement objects to XMl tests
    func testToXMLSinglePredefinedStyleItemColor() {
        let colorHEX = "#FFFFFF"
        let color = UIColor(fromHEX: colorHEX)
        let styleItem = StyleItem(.strokeColor, color, NSRange())

        let xml = parser.XMLForStyleItems([styleItem])
        let expectedXML = "<strokeColor value=\"\(colorHEX)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

    func testToXMLSinglePredefinedStyleItemUnderlineStyle() {
        let underlineStyle = "patternDashDotDot"
        let styleItem = StyleItem(.underlineStyle, NSUnderlineStyle.patternDashDotDot, NSRange())

        let xml = parser.XMLForStyleItems([styleItem])
        let expectedXML = "<underlineStyle value=\"\(underlineStyle)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

    func testToXMLSinglePredefinedStyleWidth() {
        let width: CGFloat = 4.0
        let styleItem = StyleItem(.strokeWidth, width, NSRange())

        let xml = parser.XMLForStyleItems([styleItem])
        let expectedXML = "<strokeWidth value=\"\(width.stringValue)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

    func testToXMLSinglePredefinedStyleLink() {
        let link = "asfadfgnbvdcx"
        let styleItem = StyleItem(.link, link, NSRange())

        let xml = parser.XMLForStyleItems([styleItem])
        let expectedXML = "<link value=\"\(link)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

    func testToXMLSinglePredefinedStyleFont() {
        let size: CGFloat = 16.0
        let fontName = "AvenirNext-BoldItalic"
        let font = UIFont(name: fontName, size: size)
        let styleItem = StyleItem(.font, font as Any, NSRange())

        let xml = parser.XMLForStyleItems([styleItem])
        let expectedXML = "<font name=\"\(fontName)\" size=\"\(size.stringValue)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

    func testToXMLSinglePredefinedStyleShadow() {
        let colorHEX = "#FFFFFF"
        let color = UIColor(fromHEX: colorHEX)
        let blurRadius: CGFloat = 2.0
        let offsetSize = CGSize(width: 3.0, height: 4.0)

        let shadow = NSShadow()
        shadow.shadowColor = color
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowOffset = offsetSize

        let styleItem = StyleItem(.shadow, shadow as Any, NSRange())

        let xml = parser.XMLForStyleItems([styleItem])
        let expectedXML = "<shadow color=\"\(colorHEX)\" blur=\"\(blurRadius.stringValue)\" offsetHeight=\"\(offsetSize.height.stringValue)\" offsetWidth=\"\(offsetSize.width.stringValue)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

    func testToXMLCustomStyle() {
        let link = "asfadfgnbvdcx"
        let colorHEX = "#FFFFFF"
        let color = UIColor(fromHEX: colorHEX)
        let linkStyleItem = StyleItem(.link, link, NSRange())
        let colorStyleItem = StyleItem(.strokeColor, color, NSRange())

        let xml = parser.XMLForStyleItems([linkStyleItem, colorStyleItem])
        let expectedXML = "<style link=\"\(link)\" strokeColor=\"\(colorHEX)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

    func testToXMLCustomAndPredefinedStyle() {
        let link = "asfadfgnbvdcx"
        let colorHEX = "#FFFFFF"
        let color = UIColor(fromHEX: colorHEX)
        let linkStyleItem = StyleItem(.link, link, NSRange())
        let colorStyleItem = StyleItem(.strokeColor, color, NSRange())
        let secondColorStyleItem = StyleItem(.strokeColor, color, NSRange(location: 1, end: 5))

        let xml = parser.XMLForStyleItems([linkStyleItem, colorStyleItem, secondColorStyleItem])
        let expectedXML = "<strokeColor value=\"\(colorHEX)\" range=\"1,5\"/><style link=\"\(link)\" strokeColor=\"\(colorHEX)\" range=\"0,0\"/>"

        XCTAssertEqual(xml, expectedXML)
    }

}
