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
        let text = "<foregroundColor value=\"\(colorHEX)\"><string>asdf</string></foregroundColor>"

        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.foregroundColor, color)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testTwoNestedPredefinedStyleItems() {
        let firstColorHEX = "#ffffff"
        let secondColorHEX = "#000000"

        let firstColor = UIColor(fromHEX: firstColorHEX)
        let secondColor = UIColor(fromHEX: secondColorHEX)

        let text = "<backgroundColor value=\"\(firstColorHEX)\"><foregroundColor value=\"\(secondColorHEX)\"><string>asdf</string></foregroundColor></backgroundColor>"

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedStyleItem1 = StyleItem(StyleType.backgroundColor, firstColor)
        let expectedStyleItem2 = StyleItem(StyleType.foregroundColor, secondColor)

        expectedStyleItem1.range = NSRange(location: 0, length: 4)
        expectedStyleItem2.range = NSRange(location: 0, length: 4)
        let expectedStyleItems = [expectedStyleItem1, expectedStyleItem2]

        XCTAssertEqual(styleItems, expectedStyleItems)
        XCTAssertEqual(extractedText, "asdf")
    }

    func testTwoPredefinedStyleItems() {
        let firstColorHEX = "#ffffff"
        let secondColorHEX = "#000000"

        let firstColor = UIColor(fromHEX: firstColorHEX)
        let secondColor = UIColor(fromHEX: secondColorHEX)

        let text = "<f><backgroundColor value=\"\(firstColorHEX)\"><string>asdf</string></backgroundColor><foregroundColor value=\"\(secondColorHEX)\"><string>asdf</string></foregroundColor></f>"

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedStyleItem1 = StyleItem(StyleType.backgroundColor, firstColor)
        let expectedStyleItem2 = StyleItem(StyleType.foregroundColor, secondColor)

        expectedStyleItem1.range = NSRange(location: 0, length: 4)
        expectedStyleItem2.range = NSRange(location: 4, length: 4)
        let expectedStyleItems = [expectedStyleItem1, expectedStyleItem2]

        XCTAssertEqual(styleItems, expectedStyleItems)
        XCTAssertEqual(extractedText, "asdfasdf")
    }

    func testSingleCustomStyleItem() {
        let firstColorHEX = "#ffffff"
        let secondColorHEX = "#000000"
        let string = "Test"

        let firstColor = UIColor(fromHEX: firstColorHEX)
        let secondColor = UIColor(fromHEX: secondColorHEX)

        let text = "<f><style foregroundColor=\"\(firstColorHEX)\" backgroundColor=\"\(secondColorHEX)\" name=\"m\"><m><string>\(string)</string></m></f>"

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedStyleItem1 = StyleItem(StyleType.backgroundColor, secondColor)
        let expectedStyleItem2 = StyleItem(StyleType.foregroundColor, firstColor)

        expectedStyleItem1.range = NSRange(location: 0, length: 4)
        expectedStyleItem2.range = NSRange(location: 0, length: 4)
        let expectedStyleItems = [expectedStyleItem1, expectedStyleItem2]

        XCTAssertEqual(styleItems, expectedStyleItems)
        XCTAssertEqual(extractedText, string)
    }

    func testUnderlineColor() {
        let colorHEX = "#ffffff"
        let text = "<underlineColor value=\"\(colorHEX)\"><string>asdf</string></underlineColor>"

        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.underlineColor, color)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testUnderlineStyle() {
        let underlineStyleKey = "patternDot"
        let text = "<underlineStyle value=\"\(underlineStyleKey)\"><string>asdf</string></underlineStyle>"

        let underlineStyle = NSUnderlineStyle.patternDot

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.underlineStyle, underlineStyle)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testStriketroughColor() {
        let colorHEX = "#ffffff"
        let text = "<strikethroughColor value=\"\(colorHEX)\"><string>asdf</string></strikethroughColor>"

        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.strikethroughColor, color)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testStrikethroughStyle() {
        let strikethroughStyleKey = "patternDot"
        let text = "<strikethroughStyle value=\"\(strikethroughStyleKey)\"><string>asdf</string></strikethroughStyle>"

        let strikethroughStyle = NSUnderlineStyle.patternDot

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.strikethroughStyle, strikethroughStyle)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testLink() {
        let linkValue = "https://www.google.com/"
        let text = "<link value=\"\(linkValue)\"><string>asdf</string></link>"

        let link = NSString(string: linkValue)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.link, link)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testLinkInsideCustomStyle() {
        let linkValue = "https://www.google.com/"
        let text = "<f><style link=\"\(linkValue)\" name=\"m\"><m><string>asdf</string></m></f>"

        let link = NSString(string: linkValue)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.link, link)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testStrokeColor() {
        let colorHEX = "#ffffff"
        let text = "<strokeColor value=\"\(colorHEX)\"><string>asdf</string></strokeColor>"

        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.strokeColor, color)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testStrokeColorInsideCustomStyle() {
        let colorHEX = "#ffffff"
        let text = "<m><style strokeColor=\"\(colorHEX)\" name=\"f\"><f><string>asdf</string></f></m>"

        let color = UIColor(fromHEX: colorHEX)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.strokeColor, color)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testStrokeWidth() {
        let width: CGFloat = 4.1
        let text = "<strokeWidth value=\"\(width)\"><string>asdf</string></strokeWidth>"

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.strokeWidth, width)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testStrokeWidthInsideCustomStyle() {
        let width: CGFloat = 4.0
        let text = "<m><style strokeWidth=\"\(width)\" name=\"f\"><f><string>asdf</string></f></m>"

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.strokeWidth, width)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testShadow() {
        let colorHEX = "#ffffff"
        let blurRadius: CGFloat = 2.0
        let offsetSize = CGSize(width: 3.0, height: 4.0)

        let text = "<shadow color=\"\(colorHEX)\" blur=\"\(blurRadius)\" offsetHeight=\"\(offsetSize.height)\" offsetWidth=\"\(offsetSize.width)\"><string>asdf</string></shadow>"

        let color = UIColor(fromHEX: colorHEX)
        let shadow = NSShadow()
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowOffset = offsetSize
        shadow.shadowColor = color

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.shadow, shadow, NSRange(location: 0, length: 4))
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testShadowInsideCustomStyle() {
        let colorHEX = "#ffffff"
        let blurRadius: CGFloat = 2.0
        let offsetSize = CGSize(width: 3.0, height: 4.0)

        let text = "<m><style shadowColor=\"\(colorHEX)\" shadowBlur=\"\(blurRadius)\" shadowOffsetWidth=\"\(offsetSize.width)\" shadowOffsetHeight=\"\(offsetSize.height)\" name=\"f\"><f><string>asdf</string></f></m>"

        let color = UIColor(fromHEX: colorHEX)
        let shadow = NSShadow()
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowOffset = offsetSize
        shadow.shadowColor = color

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.shadow, shadow)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testFont() {
        let size: CGFloat = 16.0
        let fontName = "AvenirNext-BoldItalic"

        let text = "<font name=\"\(fontName)\" size=\"\(size)\"><string>asdf</string></font>"

        let font = UIFont(name: fontName, size: size)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.font, font!)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testUndefinedFont() {
        let size: CGFloat = 16.0
        let fontName = "AvenirNext-Boldalic"

        let text = "<font name=\"\(fontName)\" size=\"\(size)\"><string>asdf</string></font>"

        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.font, font)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    func testFontInsideCustomStyle() {
        let size: CGFloat = 16.0
        let fontName = "AvenirNext-BoldItalic"

        let text = "<m><style fontName=\"\(fontName)\" fontSize=\"\(size)\" name=\"f\"><f><string>asdf</string></f></m>"

        let font = UIFont(name: fontName, size: size)

        let styleItems = parser.styleItemsFromXML(text)
        let extractedText = parser.extractedText

        let expectedExtractedText = "asdf"
        let styleItem = StyleItem(StyleType.font, font!)
        styleItem.range = NSRange(location: 0, length: 4)
        let expectedStyles = [styleItem]

        XCTAssertEqual(expectedStyles, styleItems)
        XCTAssertEqual(expectedExtractedText, extractedText)
    }

    // MARK: - StyleElement objects to XMl tests
    func testSinglePredefinedStyleItem() {
        let colorHEX = "#FFFFFF"
        let color = UIColor(fromHEX: colorHEX)

        let styleItem = StyleItem(.strokeColor, color)
        let text = "asdf"

        let xml = parser.XMLForStyleItems([styleItem], andText: text)
        let expectedXML = "<strokeColor value=\"\(colorHEX)\"><string>\(text)</string></strokeColor>"

        XCTAssertEqual(xml, expectedXML)
    }
}
