//
//  Utilities.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 9.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    static func rectBetween(_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> CGRect {
        let points = Utilities.beginAndEndPointForRectBetweenPoints(firstPoint, secondPoint)
        return CGRect(x: points.0.x, y: points.0.y, width: points.1.x - points.0.x, height: points.1.y - points.0.y)
    }
    
    private static func beginAndEndPointForRectBetweenPoints(_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> (CGPoint, CGPoint) {
        let beginPoint = CGPoint(x: min(firstPoint.x, secondPoint.x), y: min(firstPoint.y, secondPoint.y))
        let endPoint = CGPoint(x: max(firstPoint.x, secondPoint.x),y: max(firstPoint.y, secondPoint.y))
        
        return (beginPoint, endPoint)
    }
    
    static func convert(_ point: CGPoint, fromViewWithSize viewSize: CGSize, andContentInAspectFitModeWithSize contentSize: CGSize) -> CGPoint {
        let ratioX = viewSize.width / contentSize.width
        let ratioY = viewSize.height / contentSize.height
        
        let scale = min(ratioX, ratioY)
        
        let offsetX = (viewSize.width - contentSize.width * scale) / 2
        let offsetY = (viewSize.height - contentSize.height * scale) / 2
        
        return CGPoint(x: (point.x - offsetX) / scale, y: (point.y - offsetY) / scale)
    }
    
    static func rotateBezierPath(_ path: UIBezierPath, aroundPoint point: CGPoint, withAngle angle: CGFloat) {
        path.apply(CGAffineTransform(translationX: -point.x, y: -point.y))
        path.apply(CGAffineTransform(rotationAngle: angle + .pi / 2))
        path.apply(CGAffineTransform(translationX: point.x, y:  point.y))
    }
    
    static func angleBetweenPoint(_ point: CGPoint, andOtherPoint other: CGPoint) -> CGFloat {
        let dx = point.x - other.x
        let dy = point.y - other.y
        
        return CGFloat(atan2(dy, dx))
    }
}
