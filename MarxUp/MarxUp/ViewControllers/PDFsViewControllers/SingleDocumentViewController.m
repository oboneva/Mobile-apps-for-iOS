//
//  SingleDocumentViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 18.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "SingleDocumentViewController.h"
#import "ToolbarViewController.h"
#import "ToolboxViewController.h"

#import "Constants.h"

#import "ChangesHistory.h"
#import "Annotator.h"

@interface SingleDocumentViewController ()

@property (weak, nonatomic) IBOutlet PDFView *pdfDocumentView;
@property (weak, nonatomic) IBOutlet PDFThumbnailView *pdfDocumentThumbnailView;
@property (strong, nonatomic) UIView *toolboxView;

@property (strong, nonatomic) Annotator *annotator;

@end

@implementation SingleDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configurePDFView];
    [self configurePDFThumbnailView];
    
    self.annotator = [Annotator newForAnnotatingPDF:self.pdfDocumentView];
    for (UIViewController *childController in self.childViewControllers) {
        if ([childController isKindOfClass:ToolboxViewController.class]) {
            ToolboxViewController *toolboxController = (ToolboxViewController *)childController;
            toolboxController.toolboxItemDelegate = self.annotator;
            toolboxController.editedContentStateDelegate = self.annotator;
        }
    }
    
    [self addGestureRecognizers];
    
    [self.toolboxView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:ToolbarViewController.class]) {
        ToolbarViewController *toolbarController = segue.destinationViewController;
        toolbarController.toolbarButtonsDelegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:ToolboxViewController.class]) {
        ToolboxViewController *toolboxController = segue.destinationViewController;
        toolboxController.buttonsForContentType = ContentTypePDF;
        self.toolboxView = toolboxController.view;
    }
}

- (void)configurePDFView {
    self.pdfDocumentView.document = self.pdfDocument;
    self.pdfDocumentView.displayMode = kPDFDisplaySinglePage;
    self.pdfDocumentView.displayDirection = kPDFDisplayDirectionHorizontal;
    self.pdfDocumentView.autoScales = true;
    self.pdfDocumentView.backgroundColor = [UIColor orangeColor];
    [self.pdfDocumentView setUserInteractionEnabled:NO];
}

- (void)configurePDFThumbnailView {
    self.pdfDocumentThumbnailView.PDFView = self.pdfDocumentView;
    CGFloat tumbnailViewHeight = self.pdfDocumentThumbnailView.frame.size.height;
    self.pdfDocumentThumbnailView.thumbnailSize = CGSizeMake(100, tumbnailViewHeight * 0.8);
    self.pdfDocumentThumbnailView.layoutMode = PDFThumbnailLayoutModeHorizontal;
    self.pdfDocumentThumbnailView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGestureRecognizer:)];
    panGestureRecognizer.delegate = self;
    [self.pdfDocumentView addGestureRecognizer:panGestureRecognizer];
}

- (void)handleTap {
    [self.toolboxView setHidden:YES];
}

- (void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRec {
    CGPoint point = [gestureRec locationInView:self.pdfDocumentView];
    point = [self.pdfDocumentView convertPoint:point toPage:self.pdfDocumentView.currentPage];

    if (gestureRec.state == UIGestureRecognizerStateBegan) {
        [self.annotator beginAnnotatingAtPoint:point];
    }
    else if (gestureRec.state == UIGestureRecognizerStateEnded) {
        [self.annotator endAnnotatingAtPoint:point];
    }
    else {
        [self.annotator continueAnnotatingAtPoint:point];
    }
}

- (void)didSelectAnnotate {
    [self.pdfDocumentView setUserInteractionEnabled:YES];
}

- (void)didSelectSave {
    [self.pdfDocument writeToURL:self.pdfDocument.documentURL];
    [self.annotator clearChanges];
    [self.pdfDocumentView setUserInteractionEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectReset {
    [self.annotator reset];
}

- (void)didSelectToolbox {
    [self.toolboxView setHidden:![self.toolboxView isHidden]];
}

@end
