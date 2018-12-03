//
//  ArrowBezierPath.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 28.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ArrowBezierPath: NSObject {

    static func endLineClosed(withRect rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let tip = CGPoint(x: rect.minX + (rect.maxX - rect.minX) / 2, y: rect.minY)
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.addLine(to: tip)
        path.close()
        
        return path
    }
    
    static func endLineOpen(withRect rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let tip = CGPoint(x: rect.minX + (rect.maxX - rect.minX) / 2, y: rect.minY)
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: tip)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        return path
    }
}
