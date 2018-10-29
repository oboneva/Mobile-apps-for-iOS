//
//  DocumentPreviewTableViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 4.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <PDFKit/PDFKit.h>

#import "DocumentPreviewTableViewController.h"
#import "SingleDocumentViewController.h"

#import "DocumentPreviewTableViewCell.h"

#import "Constants.h"
#import "Utilities.h"
#import "FileManager.h"


@interface DocumentPreviewTableViewController ()

@property (strong, nonatomic) NSArray<NSURL *> *documentsURLs;

@end

@implementation DocumentPreviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.documentsURLs = [FileManager loadDocumentsOfType:@"pdf"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.documentsURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentPreviewTableViewCell *cell = (DocumentPreviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_DOCUMENT_PREVIEW_CELL forIndexPath:indexPath];
    PDFDocument *document = [[PDFDocument alloc] initWithURL:self.documentsURLs[indexPath.row]];
    cell.documentImageView.image = [self imageForPDFDocument:document withImageRect:cell.documentImageView.frame];
    cell.documentImageView.layer.borderColor = UIColor.orangeColor.CGColor;
    cell.documentImageView.layer.borderWidth = 2.0;
    cell.titleLabel.text = document.documentAttributes[PDFDocumentTitleAttribute];
    [cell.titleLabel sizeToFit];
    
    return cell;
}

- (UIImage *)imageForPDFDocument:(PDFDocument *)document withImageRect:(CGRect)cellRect{
    return [[document pageAtIndex:0] thumbnailOfSize:cellRect.size forBox:kPDFDisplayBoxArtBox];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleDocumentViewController *documentViewController = (SingleDocumentViewController *)[Utilities viewControllerWithClass:SingleDocumentViewController.class];
    documentViewController.pdfDocument = [[PDFDocument alloc] initWithURL:self.documentsURLs[indexPath.row]];

    [self presentViewController:documentViewController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

@end
