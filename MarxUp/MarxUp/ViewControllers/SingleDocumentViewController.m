//
//  SingleDocumentViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 18.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "SingleDocumentViewController.h"
#import "Constants.h"
#import "ChangesHistory.h"
#import "ToolboxInitializer.h"
#import "ToolboxItemViewController.h"
#import "Annotator.h"

@interface SingleDocumentViewController ()

@property (weak, nonatomic) IBOutlet PDFView *pdfDocumentView;
@property (weak, nonatomic) IBOutlet PDFThumbnailView *pdfDocumentThumbnailView;
@property (weak, nonatomic) IBOutlet UIScrollView *toolboxScrollView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *toolBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *annotateButton;

@property (strong, nonatomic) ChangesHistory *annotationsHistory;

//////////////////////////////////////////////////////////
@property (strong, nonatomic) PDFAnnotation *annotation;

@property (assign) BOOL isAnnotationAdded;

@property (strong, nonatomic)UIButton *previouslyPressed;
@property (assign)NSUInteger itemOption;

@property (strong, nonatomic) Annotator *annotator;

@end

@implementation SingleDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Manifesto.pdf" ofType:nil];
    self.pdfDocument = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:path]];
    
    [self configurePDFView];
    [self configurePDFThumbnailView];
    [self configureToolbox];
    
    [self annotationRelatedButtonsSetHidden:YES];
    self.annotationsHistory = [ChangesHistory newWithChangeType:PDFAnnotation.class];
    [self addGestureRecognizers];
    
    /////////////
    self.annotator = [Annotator new];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)configureToolbox {
    ToolboxInitializer *initializer = [ToolboxInitializer newToolboxInitializer];
    [initializer addToolboxItemsToView:self.toolboxScrollView withTarget:self andSelector:@selector(toolboxItemPressed:)];
    [self.toolboxScrollView setHidden:YES];
}

- (void)annotationRelatedButtonsSetHidden:(BOOL)hidden {
    [self.saveButton setHidden:hidden];
    [self.resetButton setHidden:hidden];
    [self.toolBoxButton setHidden:hidden];
    [self.view sendSubviewToBack:self.toolboxScrollView];
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGestureRecognizer:)];
    panGestureRecognizer.delegate = self;
    [self.pdfDocumentView addGestureRecognizer:panGestureRecognizer];
}

- (void)addAnnotation {
    [self.annotator updatePropertiesForAnnotation:self.annotation];
    [self.pdfDocumentView.currentPage addAnnotation:self.annotation];
}

- (void)undoAnnotation {
    if ([self.annotationsHistory couldUndo]) {
        [self.pdfDocumentView.currentPage removeAnnotation:[self.annotationsHistory lastChange]];
        [self.annotationsHistory undoChange];
    }
}

- (void)redoAnnotation {
    if ([self.annotationsHistory couldRedo]) {
        [self.annotationsHistory redoChange];
        [self.pdfDocumentView.currentPage addAnnotation:[self.annotationsHistory lastChange]];
    }
}

- (void)handleTap {
    if (![self.toolboxScrollView isHidden]) {
        [self.toolboxScrollView setHidden:YES];
        [self.view sendSubviewToBack:self.toolboxScrollView];
    }
}

- (void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRec {
    CGPoint point = [gestureRec locationInView:self.pdfDocumentView];
    point = [self.pdfDocumentView convertPoint:point toPage:self.pdfDocumentView.currentPage];
    
    if (gestureRec.state == UIGestureRecognizerStateBegan) {
        [self drawingOfAnnotationBeganAtPoint:point];
    }
    else if (gestureRec.state == UIGestureRecognizerStateEnded) {
        [self drawingOfAnnotationEndedAtPoint:point];
    }
    else {
        [self drawingOfAnnotationContinuedAtPoint:point];
    }
}

- (void)drawingOfAnnotationBeganAtPoint:(CGPoint)point {
    self.annotator.lastPoint = point;
    if (self.previouslyPressed.tag != ToolboxItemTypeArrow) {
        [self.annotator startDrawingWithBezierPathAtPoint:point];
    }
    
    self.isAnnotationAdded = false;
}

- (void)drawingOfAnnotationContinuedAtPoint:(CGPoint)point {
    if (self.previouslyPressed.tag == ToolboxItemTypeArrow) {
        [self removePreviousVersionOfAnnotationWithPoint:self.annotator.lastPoint];
        CGRect annotationBounds = [self.pdfDocumentView.currentPage boundsForBox:kPDFDisplayBoxMediaBox];
        self.annotation = [[PDFAnnotation alloc] initWithBounds:annotationBounds forType:PDFAnnotationSubtypeLine withProperties:nil];
        self.annotation.endPoint = point;
        self.annotation.startPoint = self.annotator.lastPoint;
        [self addAnnotation];
    }
    else {
        [self updateBezierPathWithPoint:point];
        [self removePreviousVersionOfAnnotationWithPoint:point];
        [self addAnnotationWithCurrentBezierPath];
    }
}

- (void)drawingOfAnnotationWithBezierPathContinuedAtPoint:(CGPoint)point {
    [self updateBezierPathWithPoint:point];
    [self removePreviousVersionOfAnnotationWithPoint:point];
    [self addAnnotationWithCurrentBezierPath];
}

-(void)removePreviousVersionOfAnnotationWithPoint:(CGPoint)point {
    if (self.isAnnotationAdded) {
        [self.pdfDocumentView.currentPage removeAnnotation:self.annotation];
    }
    else {
        self.annotator.lastPoint = point;
        self.isAnnotationAdded = true;
    }
}

- (void)updateBezierPathWithPoint:(CGPoint)point {
    if (self.previouslyPressed.tag == ToolboxItemTypePen) {
        [self.annotator updateBezierPathWithPoint:point];
    }
    else if (self.previouslyPressed.tag == ToolboxItemTypeShape) {
        [self drawShapeFromType:self.itemOption atPoint:point];
    }
}

- (void)drawShapeFromType:(ShapeType)shapeType atPoint:(CGPoint)point {
    [self.annotator addShapeWithBezierPathFromType:shapeType wihtEndPoint:point];
}

- (void)drawingOfAnnotationEndedAtPoint:(CGPoint)point {
    if (self.previouslyPressed.tag == ToolboxItemTypePen) {
        [self.annotator updateBezierPathWithPoint:point];
    }
    if (self.previouslyPressed.tag != ToolboxItemTypeArrow) {
        [self.pdfDocumentView.currentPage removeAnnotation:self.annotation];
        [self addAnnotationWithCurrentBezierPath];
    }
    [self.annotationsHistory addChange:self.annotation];
}

- (void)addAnnotationWithCurrentBezierPath {
    CGRect annotationBounds = [self.pdfDocumentView.currentPage boundsForBox:kPDFDisplayBoxMediaBox];
    self.annotation = [[PDFAnnotation alloc] initWithBounds:annotationBounds forType:PDFAnnotationSubtypeInk withProperties:nil];
    [self.annotator addBezierPathToAnnotation:self.annotation];
    [self addAnnotation];
}

- (void)didChooseOption:(id)option forItem:(ToolboxItemType)itemType {
    [self.annotator updatePropertie:option fromType:itemType];
}

- (void)toolboxItemPressed:(UIButton *)button {///////////////////////////////////
    self.previouslyPressed.backgroundColor = [UIColor lightGrayColor];
    button.backgroundColor = [UIColor darkGrayColor];
    self.previouslyPressed = button;
    
    if (button.tag == ToolboxItemTypeUndo) {
        [self undoAnnotation];
    }
    else if (button.tag == ToolboxItemTypeRedo) {
        [self redoAnnotation];
    }
    else if (button.tag == ToolboxItemTypeTextUnderline) {
        [self addAnnotationFromSubtype:PDFAnnotationSubtypeUnderline withMarkUpType:kPDFMarkupTypeUnderline];
    }
    else if (button.tag == ToolboxItemTypeTextStrikeThrough) {
        [self addAnnotationFromSubtype:PDFAnnotationSubtypeStrikeOut withMarkUpType:kPDFMarkupTypeStrikeOut];
    }
    else if (button.tag == ToolboxItemTypeTextHighlight) {
        [self addAnnotationFromSubtype:PDFAnnotationSubtypeHighlight withMarkUpType:kPDFMarkupTypeHighlight];
    }
    else if ([self shouldPresentOptionsForButton:button]) {
        [self presentOptionsForToolboxItem:button];
    }
}

- (void)presentOptionsForToolboxItem:(UIButton *)item {
    ToolboxItemViewController *viewController = (ToolboxItemViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:ID_TOOLBOX_ITEM_VIEW_CONTROLLER];
    
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    viewController.popoverPresentationController.delegate = self;
    viewController.popoverPresentationController.sourceView = self.toolboxScrollView;
    viewController.popoverPresentationController.sourceRect = item.frame;
    viewController.itemType = item.tag;
    viewController.toolboxItemsOptionsDelegate = self;
    viewController.preferredContentSize = CGSizeMake(100, 150);
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BOOL)shouldPresentOptionsForButton:(UIButton *)button {
    return button.tag == ToolboxItemTypeArrow || button.tag == ToolboxItemTypeColor || button.tag == ToolboxItemTypeShape || button.tag == ToolboxItemTypeWidth;
}

- (void)addAnnotationFromSubtype:(PDFAnnotationSubtype)subtype withMarkUpType:(PDFMarkupType)markUp {
    for (PDFSelection *lineSelection in self.pdfDocumentView.currentSelection.selectionsByLine.copy) {
        PDFAnnotation *annotation = [[PDFAnnotation alloc] initWithBounds:[lineSelection boundsForPage:self.pdfDocumentView.currentPage] forType:subtype withProperties:nil];
        [annotation setMarkupType:markUp];
        [self addAnnotation];
    }
}

- (IBAction)onAnnotateTap:(id)sender {
    [self.pdfDocumentView setUserInteractionEnabled:YES];
    [self annotationRelatedButtonsSetHidden:NO];
}

- (IBAction)onSaveTap:(id)sender {
    [self.pdfDocument writeToURL:self.pdfDocument.documentURL];
    [self.annotationsHistory cleanAllChanges];
    
    [self.pdfDocumentView setUserInteractionEnabled:NO];
    [self annotationRelatedButtonsSetHidden:YES];
}

- (IBAction)onResetTap:(id)sender {
    for (PDFAnnotation *annotation in [self.annotationsHistory getAllChanges]) {
        [self.pdfDocumentView.currentPage removeAnnotation:annotation];
    }
    [self.annotationsHistory cleanAllChanges];
}

- (IBAction)onToolboxTap:(id)sender {
    if ([self.toolboxScrollView isHidden]) {
        [self.toolboxScrollView setHidden:NO];
        [self.view bringSubviewToFront:self.toolboxScrollView];
    }
    else {
        [self.toolboxScrollView setHidden:YES];
        [self.view sendSubviewToBack:self.toolboxScrollView];
    }
}

@end
