//
//  DocumentPreviewTableViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 4.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "DocumentPreviewTableViewController.h"
#import "DocumentPreviewTableViewCell.h"
#import "SingleDocumentViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import <PDFKit/PDFKit.h>

@interface DocumentPreviewTableViewController ()

@property (strong, nonatomic) NSArray<NSString *> *documentsPaths;

@end

@implementation DocumentPreviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.documentsPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.documentsPaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentPreviewTableViewCell *cell = (DocumentPreviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_DOCUMENT_PREVIEW_CELL forIndexPath:indexPath];
    PDFDocument *document = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:self.documentsPaths[indexPath.row]]];
    cell.documentImageView.image = [self imageForPDFDocument:document withImageRect:cell.documentImageView.frame];
    cell.documentImageView.layer.borderColor = UIColor.orangeColor.CGColor;
    cell.documentImageView.layer.borderWidth = 2.0;
    cell.titleLabel.text = document.documentAttributes[PDFDocumentTitleAttribute];
    [cell.titleLabel sizeToFit];
    
    return cell;
}

- (UIImage *)imageForPDFDocument:(PDFDocument *)document withImageRect:(CGRect)cellRect{
    PDFPage *firstPage = [document pageAtIndex:0];
//    CGRect firstPageRect = [firstPage boundsForBox:kPDFDisplayBoxMediaBox];
//    UIGraphicsImageRenderer *imageRenderer = [[UIGraphicsImageRenderer alloc] initWithSize:cellRect.size];
//
//    UIImage *image = [imageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
//        [[UIColor whiteColor] set];
//        [rendererContext fillRect:cellRect];
//
//        CGContextFillRect(rendererContext.CGContext, cellRect);
//        CGContextTranslateCTM(rendererContext.CGContext, 0, cellRect.size.height);
//        CGContextScaleCTM(rendererContext.CGContext, 1, -1);
//
//        CGContextDrawPDFPage(rendererContext.CGContext, firstPage.pageRef);
//    }];
    
    UIImage *image = [firstPage thumbnailOfSize:cellRect.size forBox:kPDFDisplayBoxArtBox];

    return image;
    //return (UIImage *)nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleDocumentViewController *documentViewController = (SingleDocumentViewController *)[Utilities viewControllerWithClass:SingleDocumentViewController.class];
    documentViewController.pdfDocument = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:self.documentsPaths[indexPath.row]]];

    [self presentViewController:documentViewController animated:YES completion:nil];
}

@end
