//
//  Annotator.m
//  MarxUp
//
//  Created by A-Team User on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "Annotator.h"

@interface Annotator ()

@property (strong, nonatomic) UIColor *color;
@property (assign) CGFloat lineWidth;
@property (assign) PDFLineStyle endLineStyle;
@property (assign) ShapeType shape;
@property (strong, nonatomic) UIBezierPath *path;

@end

@implementation Annotator

- (void)startDrawingWithBezierPathAtPoint:(CGPoint)point {
    self.path = [UIBezierPath new];
    self.path.lineWidth = self.lineWidth;
    [self.path moveToPoint:point];
}

- (void)updatePropertie:(NSInteger)property fromType:(ToolboxItemType)type {
    if (type == ToolboxItemTypeWidth) {
        self.lineWidth = property;
    }
    else if (type == ToolboxItemTypeArrow && property == ArrowEndLineTypeOpen) {
        self.endLineStyle = kPDFLineStyleOpenArrow;
    }
    else if (type == ToolboxItemTypeArrow && property == ArrowEndLineTypeClosed) {
        self.endLineStyle = kPDFLineStyleClosedArrow;
    }
    else if (type == ToolboxItemTypeShape) {
        self.shape = property;
    }
}

- (void)updateColor:(UIColor *)color {
    self.color = color;
}

- (void)updateLineWidth:(CGFloat)width {
    self.lineWidth = width;
}

- (void)updatePropertiesForAnnotation:(PDFAnnotation *)pdfAnnotation {
    pdfAnnotation.color = self.color;
    if (self.endLineStyle) {
        pdfAnnotation.endLineStyle = self.endLineStyle;
        pdfAnnotation.border.lineWidth = self.lineWidth;
    }
}

- (void)updateBezierPathWithPoint:(CGPoint)point {
    [self.path addLineToPoint:point];
}

- (void)addBezierPathToAnnotation:(PDFAnnotation *)annotation {
    [annotation addBezierPath:self.path];
}


- (void)addShapeWithBezierPathAtPoint:(CGPoint)point {
    CGFloat beginPointX = MIN(self.lastPoint.x, point.x);
    CGFloat beginPointY = MIN(self.lastPoint.y, point.y);
    CGFloat endPointX = MAX(self.lastPoint.x, point.x);
    CGFloat endPointY = MAX(self.lastPoint.y, point.y);
    CGFloat width = endPointX - beginPointX;
    CGFloat height = endPointY - beginPointY;
    
    CGRect shapeRect = CGRectMake(beginPointX, beginPointY, width, height);
    
    if (self.shape == ShapeTypeRegularRectangle) {
        self.path = [UIBezierPath bezierPathWithRect:shapeRect];
    }
    else if (self.shape == ShapeTypeCircle) {
        self.path = [UIBezierPath bezierPathWithOvalInRect:shapeRect];
    }
    else if (self.shape == ShapeTypeRoundedRectangle) {
        self.path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:5.0];
    }
    self.path.lineWidth = self.lineWidth;
}

@end
