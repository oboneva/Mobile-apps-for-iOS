//
//  Annotator.m
//  MarxUp
//
//  Created by A-Team User on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "Annotator.h"
#import "ChangesHistory.h"

#import "Utilities.h"
#import "Constants.h"

#define ROUNDED_RECT_CORNER_RADIUS 0.5

@interface Annotator ()

@property (strong, nonatomic) ChangesHistory *annotationsHistory;
@property (assign) ContentType annotatedContent;
@property (assign) ToolboxItemType choosenItem;

@property (strong, nonatomic) UIColor *color;
@property (assign) CGFloat lineWidth;
@property (assign) PDFLineStyle endLineStyle;
@property (assign) ShapeType shape;
@property (strong, nonatomic) UIBezierPath *path;

@property (strong, nonatomic) PDFAnnotation *annotation;
@property (assign) BOOL isAnnotationAdded;
@property (strong, nonatomic) PDFView *annotatedPDF;

@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *changedImage;
@property (strong, nonatomic) UIImageView *annotatedImage;

@property (assign) CGPoint lastPoint;
@property (assign) CGPoint startPoint;

@end

@implementation Annotator

+ (instancetype)newForAnnotatingImage:(UIImageView *)imageView {
    Annotator *new = [Annotator new];
    new.annotatedImage = imageView;
    new.originalImage = imageView.image;
    new.changedImage = imageView.image.copy;
    [new setDefultValuesToProperties];
    new.annotationsHistory = [ChangesHistory newWithChangeType:UIImage.class];
    new.annotatedContent = ContentTypeImage;
    
    return new;
}

+ (instancetype)newForAnnotatingPDF:(PDFView *)pdfView {
    Annotator *new = [Annotator new];
    new.annotatedPDF = pdfView;
    [new setDefultValuesToProperties];
    new.annotationsHistory = [ChangesHistory newWithChangeType:PDFAnnotation.class];
    new.annotatedContent = ContentTypePDF;
    
    return new;
}

- (void)beginAnnotatingAtPoint:(CGPoint)point {
    self.lastPoint = point;
    self.startPoint = point;
    if (self.annotatedContent == ContentTypeImage) {
        UIGraphicsBeginImageContext(self.annotatedImage.image.size);
        [self.changedImage drawAtPoint:CGPointZero];
    }
    if (self.choosenItem != ToolboxItemTypeArrow) {
        [self beginDrawingWithBezierPathAtPoint:point];
    }
    
    self.isAnnotationAdded = false;
}

- (void)endAnnotatingAtPoint:(CGPoint)point {
    [self continueAnnotatingAtPoint:point];
    if (self.annotatedContent == ContentTypeImage) {
        self.changedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    [self.annotationsHistory addChange:self.annotation];
}

- (void)continueAnnotatingAtPoint:(CGPoint)point {
    [self updateBezierPathWithPoint:point];
    [self removePreviousVersionOfAnnotationWithPoint:point];
    
    if (self.annotatedContent == ContentTypeImage) {
        [self strokePathOverImage];
    }
    else {
        [self addAnnotationWithCurrentBezierPath];
        [self strokePath];
    }
    
    self.lastPoint = point;
}

- (void)strokePathOverImage {
    [self strokePath];
    self.annotatedImage.image = UIGraphicsGetImageFromCurrentImageContext();
}

- (void)setDefultValuesToProperties {
    self.color = UIColor.blackColor;
    self.lineWidth = 3;
    self.choosenItem = ToolboxItemTypePen;
}

- (void)beginDrawingWithBezierPathAtPoint:(CGPoint)point {
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

- (void)updatePropertiesForAnnotation {
    self.annotation.color = self.color;
    self.annotation.border.lineWidth = self.lineWidth;
}

- (void)updateBezierPathWithPoint:(CGPoint)point {
    if (self.choosenItem == ToolboxItemTypePen) {
        [self.path addLineToPoint:point];
    }
    else if (self.choosenItem == ToolboxItemTypeShape) {
        [self addShapeWithBezierPathAtPoint:point];
    }
    else if (self.choosenItem == ToolboxItemTypeArrow) {
        [self addArrowWithBezierPathAtPoint:point];
    }
}

-(void)removePreviousVersionOfAnnotationWithPoint:(CGPoint)point {
    if (self.annotatedContent == ContentTypePDF) {
        if (self.isAnnotationAdded) {
            [self.annotatedPDF.currentPage removeAnnotation:self.annotation];
        }
        else {
            self.lastPoint = point;
            self.isAnnotationAdded = true;
        }
    }
    else if (self.annotatedContent == ContentTypeImage) {
        [self.changedImage drawAtPoint:CGPointZero];
    }
}

- (void)addAnnotationWithCurrentBezierPath {
    CGRect annotationBounds = [self.annotatedPDF.currentPage boundsForBox:kPDFDisplayBoxMediaBox];
    self.annotation = [[PDFAnnotation alloc] initWithBounds:annotationBounds forType:PDFAnnotationSubtypeInk withProperties:nil];
    [self updatePropertiesForAnnotation];
    [self.annotation addBezierPath:self.path];
    [self.annotatedPDF.currentPage addAnnotation:self.annotation];
}
    
- (void)addShapeWithBezierPathAtPoint:(CGPoint)point {
    CGRect shapeRect = [Utilities rectBetweenPoint:point andOtherPoint:self.startPoint];
    
    if (self.shape == ShapeTypeRegularRectangle) {
        self.path = [UIBezierPath bezierPathWithRect:shapeRect];
    }
    else if (self.shape == ShapeTypeCircle) {
        self.path = [UIBezierPath bezierPathWithOvalInRect:shapeRect];
    }
    else if (self.shape == ShapeTypeRoundedRectangle) {
        self.path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:ROUNDED_RECT_CORNER_RADIUS];
    }
    self.path.lineWidth = self.lineWidth;
}

- (void)addArrowWithBezierPathAtPoint:(CGPoint)point {
    self.path = [UIBezierPath bezierPath];
    [self.path moveToPoint:self.startPoint];
    [self.path addLineToPoint:point];
    
    CGPoint pointForVerticalLine = CGPointMake(point.x, self.startPoint.y + (point.y - self.startPoint.y) * 0.3);
    CGPoint pointforHorizontalLine = CGPointMake(self.startPoint.x + (point.x - self.startPoint.x) * 0.3, point.y);
    if (point.y < self.startPoint.y) {
            pointForVerticalLine = CGPointMake(point.x, point.y + (self.startPoint.y - point.y) * 0.3);
    }
    if(point.x < self.startPoint.x) {
            pointforHorizontalLine = CGPointMake(point.x + (self.startPoint.x - point.x) * 0.3, point.y);
    }
    
    [self.path moveToPoint:point];
    [self.path addLineToPoint:pointForVerticalLine];
    
    [self.path moveToPoint:point];
    [self.path addLineToPoint:pointforHorizontalLine];
    
    if (self.endLineStyle == kPDFLineStyleClosedArrow) {
        UIGraphicsBeginImageContext(self.annotatedPDF.frame.size);
        
        [self.path moveToPoint:pointforHorizontalLine];
        [self.path addLineToPoint:pointForVerticalLine];
        
        [self.color setFill];
        [self.path closePath];
        [self.path fill];
        
        UIGraphicsEndImageContext();
    }
    
    self.path.lineWidth = self.lineWidth;
}

- (void)addAnnotationFromSubtype:(PDFAnnotationSubtype)subtype withMarkUpType:(PDFMarkupType)markUp {
    for (PDFSelection *lineSelection in self.annotatedPDF.currentSelection.selectionsByLine) {
        self.annotation = [[PDFAnnotation alloc] initWithBounds:[lineSelection boundsForPage:self.annotatedPDF.currentPage] forType:subtype withProperties:nil];
        [self.annotation setMarkupType:markUp];
        [self updatePropertiesForAnnotation];
        [self.annotatedPDF.currentPage addAnnotation:self.annotation];
        [self.annotationsHistory addChange:self.annotation];
    }
}

- (void)strokePath {
    [self.color setStroke];
    self.path.lineWidth = self.lineWidth;
    [self.path stroke];
}

- (UIImage *)getOriginalImage {
    return self.originalImage;
}

- (UIImage *)getCurrentImage {
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (void)didChooseTextAnnotationFromType:(ToolboxItemType)type {
    if (type == ToolboxItemTypeTextHighlight) {
        [self addAnnotationFromSubtype:PDFAnnotationSubtypeHighlight withMarkUpType:kPDFMarkupTypeHighlight];
    }
    else if (type == ToolboxItemTypeTextStrikeThrough) {
        [self addAnnotationFromSubtype:PDFAnnotationSubtypeStrikeOut withMarkUpType:kPDFMarkupTypeStrikeOut];
    }
    else if (type == ToolboxItemTypeTextUnderline) {
        [self addAnnotationFromSubtype:PDFAnnotationSubtypeUnderline withMarkUpType:kPDFMarkupTypeUnderline];
    }
}

- (void)didChoosePen {
    self.choosenItem = ToolboxItemTypePen;
}

- (void)didChooseOption:(NSInteger)option forType:(ToolboxItemType)itemType {
    if (itemType == ToolboxItemTypeShape || itemType == ToolboxItemTypeArrow) {
        self.choosenItem = itemType;
    }
    [self updatePropertie:option fromType:itemType];
}

- (void)didChooseColor:(UIColor *)color {
    self.color = color;
}

- (void)didChooseLineWidth:(CGFloat)width {
    self.lineWidth = width;
}

- (void)didSelectRedo {
    if ([self.annotationsHistory redoChange]) {
        [self.annotatedPDF.currentPage addAnnotation:[self.annotationsHistory lastChange]];
    }
}

- (void)didSelectUndo {
    if ([self.annotationsHistory undoChange]) {
        [self.annotatedPDF.currentPage removeAnnotation:[self.annotationsHistory lastInvisibleChange]];
    }
}

- (void)clearChanges {
    [self.annotationsHistory cleanAllChanges];
}

- (void)reset {
    if (self.annotatedContent == ContentTypePDF) {
        for (PDFAnnotation *annotation in [self.annotationsHistory getAllChanges]) {
            [self.annotatedPDF.currentPage removeAnnotation:annotation];
        }
    }
    else {
        self.annotatedImage.image = self.originalImage;
    }
    [self clearChanges];
}

@end
