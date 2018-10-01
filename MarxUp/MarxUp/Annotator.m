//
//  Annotator.m
//  MarxUp
//
//  Created by A-Team User on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "Annotator.h"

@implementation Annotator

- (void)startDrawingWithBezierPathAtPoint:(CGPoint)point {
    self.path = [UIBezierPath new];
    [self.path moveToPoint:point];
}

- (void)updatePropertie:(id)property fromType:(ToolboxItemType)type {
    if (type == ToolboxItemTypeColor) {
        self.color = property;
    }
    else if (type == ToolboxItemTypeWidth) {
        self.lineWidth = [property doubleValue];
    }
    else if (type == ToolboxItemTypeArrow) {
        self.endLineStyle = [property integerValue];
    }
}

- (void)updatePropertiesForAnnotation:(PDFAnnotation *)pdfAnnotation {
    pdfAnnotation.color = self.color;
    self.path.lineWidth = self.lineWidth;
    
    if (self.endLineStyle) {
        pdfAnnotation.endLineStyle = kPDFLineStyleClosedArrow;
    }
}

- (void)updateBezierPathWithPoint:(CGPoint)point {
    [self.path addLineToPoint:point];
}

- (void)addBezierPathToAnnotation:(PDFAnnotation *)annotation {
    [annotation addBezierPath:self.path];
}


- (void)addShapeWithBezierPathFromType:(ShapeType)type wihtEndPoint:(CGPoint)point {
    CGFloat beginPointX = MIN(self.lastPoint.x, point.x);
    CGFloat beginPointY = MIN(self.lastPoint.y, point.y);
    CGFloat endPointX = MAX(self.lastPoint.x, point.x);
    CGFloat endPointY = MAX(self.lastPoint.y, point.y);
    CGFloat width = endPointX - beginPointX;
    CGFloat height = endPointY - beginPointY;
    
    CGRect shapeRect = CGRectMake(beginPointX, beginPointY, width, height);
    
    if (type == ShapeTypeRegularRectangle) {
        self.path = [UIBezierPath bezierPathWithRect:shapeRect];
    }
    else if (type == ShapeTypeCircle) {
        self.path = [UIBezierPath bezierPathWithOvalInRect:shapeRect];
    }
    else if (type == ShapeTypeRoundedRectangle) {
        self.path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:5.0];
    }
}

@end
