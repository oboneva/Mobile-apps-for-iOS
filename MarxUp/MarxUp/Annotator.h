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
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface Annotator : NSObject <ToolboxItemDelegate, EditedContentStateDelegate>

+ (instancetype)newForAnnotatingImage:(UIImageView *)imageView;
+ (instancetype)newForAnnotatingPDF:(PDFView *)pdfView;

- (void)beginAnnotatingAtPoint:(CGPoint)point;
- (void)endAnnotatingAtPoint:(CGPoint)point;
- (void)continueAnnotatingAtPoint:(CGPoint)point;

- (UIImage *)getOriginalImage;
- (UIImage *)getCurrentImage;

- (void)clearChanges;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
