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

@property (assign) CGPoint lastPoint;

- (void)updatePropertiesForAnnotation:(PDFAnnotation *)pdfAnnotation;
- (void)updateBezierPathWithPoint:(CGPoint) point;
- (void)startDrawingWithBezierPathAtPoint:(CGPoint)point;
- (void)updatePropertie:(NSInteger)property fromType:(ToolboxItemType)type;
- (void)updateColor:(UIColor *)color;
- (void)updateLineWidth:(CGFloat)width;
- (void)addBezierPathToAnnotation:(PDFAnnotation *)annotation;
- (void)addShapeWithBezierPathAtPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
