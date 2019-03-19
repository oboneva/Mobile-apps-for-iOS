//
//  StyleItemsModifier.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 18.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import UIKit

class StyleItemsModifier: NSObject {

    static func styleItemsAppending(_ newItem: StyleItem, to items: [StyleItem]) -> [StyleItem] {
        var styleItems = items

        styleItems.removeAll { (item: StyleItem) -> Bool in  //removes all entirely overlapped by the new one
             item.type == newItem.type &&
                item.range.location > newItem.range.location &&
                item.range.end < newItem.range.end
        }

        let itemsToModify = styleItems.filter { $0.type == newItem.type }

        //      case: new range < old
        let itemsOverlappingTheNewStyle = itemsToModify.filter { (item) -> Bool in
            item.range.location < newItem.range.location && item.range.end > newItem.range.end
        } // those will be split

        //split - right part
        let itemsPlacedAfterTheNewItem = itemsOverlappingTheNewStyle.map { (item) -> StyleItem in
            return StyleItem(newItem.type, item.value, NSRange(location: newItem.range.end,
                                                               end: item.range.end))
        }

        styleItems.append(contentsOf: itemsPlacedAfterTheNewItem)

        //split - left part
        itemsOverlappingTheNewStyle.forEach { (item) in
            item.range = NSRange(location: item.range.location, end: newItem.range.location)
        }

        //      case: end of item is overlapped -> set new end
        itemsToModify
            .filter {
                return $0.range.end > newItem.range.location && $0.range.end < newItem.range.end }
            .forEach {
                $0.range = NSRange(location: $0.range.location, end: newItem.range.location)
        }

        //      case: location of item is overlapped -> set new location
        itemsToModify
            .filter {
                return newItem.range.end > $0.range.location && newItem.range.end < $0.range.end }
            .forEach {
                $0.range = NSRange(location: newItem.range.end, end: $0.range.end)
        }

        return StyleItemsModifier.appendSequenceOfSameItemsIfNeededBeforeAddingNewItem(newItem, to: styleItems)
    }

    //shorter len
    private static func appendSequenceOfSameItemsIfNeededBeforeAddingNewItem(_ newItem: StyleItem,
                                                                             to items: [StyleItem]) -> [StyleItem] {
        var styleItems = items
        var sameElementsNextToTheNew = styleItems.popAll { (item) -> (Bool) in
             item.type == newItem.type &&
                item.valueIsEqualToValue(newItem.value) &&
                (item.range.location == newItem.range.end ||
                item.range.end == newItem.range.location)
        }

        guard sameElementsNextToTheNew.count > 0 else {
            styleItems.append(newItem)
            return styleItems
        }

        sameElementsNextToTheNew.append(newItem)
        sameElementsNextToTheNew.sort { (item1, item2) -> Bool in
            item1.range.location < item2.range.location
        }

        let appended = StyleItemsModifier.appendSequenceOfSameStyleItems(sameElementsNextToTheNew)
        styleItems.append(appended)

        return styleItems
    }

    private static func appendSequenceOfSameStyleItems(_ styleItems: [StyleItem]) -> StyleItem {
        return StyleItem(styleItems[0].type,
                         styleItems[0].value,
                         NSRange(location: styleItems[0].range.location,
                                 end: styleItems.last!.range.end))
    }
}
