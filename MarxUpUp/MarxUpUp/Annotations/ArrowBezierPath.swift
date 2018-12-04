//
//  ArrowBezierPath.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 28.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ArrowBezierPath: NSObject {
    
    class func endLine(atPoint point: CGPoint, fromType type: ArrowEndLineType) -> UIBezierPath {
        let capSize = CGFloat(20)
        let rect = CGRect(x: point.x - capSize / 2, y: point.y, width: capSize, height: capSize)
        
        let points = ArrowBezierPath.pointsForTriangleInRect(rect)
        let path = UIBezierPath(byConnectingThePoints: points)
        if type == .Closed { path.close() }
        
        return path
    }

    private class func tipForTriangleInRect(_ rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.minX + (rect.maxX - rect.minX) / 2, y: rect.minY)
    }
    
    private class func pointsForTriangleInRect(_ rect: CGRect) -> [CGPoint] {
        return [CGPoint(x: rect.minX, y: rect.maxY), ArrowBezierPath.tipForTriangleInRect(rect), CGPoint(x: rect.maxX, y: rect.maxY)]
    }
}

extension UIBezierPath {
    convenience init(byConnectingThePoints points: [CGPoint]) {
        self.init()
        self.move(to: points[0])
        points.forEach({ self.addLine(to: $0) })
    }
}
