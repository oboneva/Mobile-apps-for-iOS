//
//  Utilities.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 9.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    class func rectBetween(_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> CGRect {
        let beginPointX = min(firstPoint.x, secondPoint.x)
        let beginPointY = min(firstPoint.y, secondPoint.y)
        
        let endPointX = max(firstPoint.x, secondPoint.x)
        let endPointY = max(firstPoint.y, secondPoint.y)
        
        let width = endPointX - beginPointX
        let height = endPointY - beginPointY
        
        return CGRect(x: beginPointX, y: beginPointY, width: width, height: height)
    }
    
    class func convert(_ point: CGPoint, fromViewWithSize viewSize: CGSize, andContentInAspectFitModeWithSize contentSize: CGSize) -> CGPoint {
        let ratioX = viewSize.width / contentSize.width
        let ratioY = viewSize.height / contentSize.height
        
        let scale = min(ratioX, ratioY)
        
        let offsetX = (viewSize.width - contentSize.width * scale) / 2
        let offsetY = (viewSize.height - contentSize.height * scale) / 2
        
        return CGPoint(x: (point.x - offsetX) / scale, y: (point.y - offsetY) / scale)
    }
}
