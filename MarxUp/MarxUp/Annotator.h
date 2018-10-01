//
//  Annotator.h
//  MarxUp
//
//  Created by A-Team User on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface Annotator : NSObject

@property (strong, nonatomic) UIColor *color;
@property (assign) CGFloat lineWidth;
@property (assign) PDFLineStyle endLineStyle;

@property (assign) CGPoint lastPoint;
@property (strong, nonatomic) UIBezierPath *path;

- (void)updatePropertiesForAnnotation:(PDFAnnotation *)pdfAnnotation;
- (void)updateBezierPathWithPoint:(CGPoint) point;
- (void)startDrawingWithBezierPathAtPoint:(CGPoint)point;
- (void)updatePropertie:(id)property fromType:(ToolboxItemType)type;
- (void)addBezierPathToAnnotation:(PDFAnnotation *)annotation;
- (void)addShapeWithBezierPathFromType:(ShapeType)type wihtEndPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
