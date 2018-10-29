//
//  SingleDocumentViewController.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 18.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>
#import "Protocols.h"

@interface SingleDocumentViewController : UIViewController <UIGestureRecognizerDelegate, ToolbarButtonsDelegate>

@property (strong, nonatomic) PDFDocument *pdfDocument;

@end
