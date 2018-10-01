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

@interface SingleDocumentViewController ()

@property (weak, nonatomic) IBOutlet PDFView *pdfDocumentView;
@property (weak, nonatomic) IBOutlet PDFThumbnailView *pdfDocumentThumbnailView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *toolBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *annotateButton;

@property (strong, nonatomic) ChangesHistory *annotationsHistory;

//////////////////////////////////////////////////////////
@property (assign) CGPoint lastPoint;
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) PDFAnnotation *annotation;
@property (weak, nonatomic) IBOutlet UIScrollView *toolboxScrollView;
@property (assign) BOOL isAnnotationAdded;

@property (strong, nonatomic)UIButton *previouslyPressed;
@property (strong, nonatomic)NSMutableArray<PDFAnnotation *> *removedAnnotations;
@property (assign)NSUInteger itemOption;

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
    
    ///////////////
    self.removedAnnotations = [NSMutableArray new];
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
    else if ([self shouldPresentOptionsToButton:button]) {
        NSLog(@"I Clicked a button %ld version2",(long)button.tag);
        ToolboxItemViewController *viewController = (ToolboxItemViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:ID_TOOLBOX_ITEM_VIEW_CONTROLLER];
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        viewController.popoverPresentationController.delegate = self;
        viewController.popoverPresentationController.sourceView = self.toolboxScrollView;
        viewController.popoverPresentationController.sourceRect = button.frame;
        viewController.itemType = button.tag;
        viewController.toolboxItemsOptionsDelegate = self;
        viewController.preferredContentSize = CGSizeMake(100, 150);
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (BOOL)shouldPresentOptionsToButton:(UIButton *)button {
    return button.tag == ToolboxItemTypeArrow || button.tag == ToolboxItemTypeColor || button.tag == ToolboxItemTypeShape || button.tag == ToolboxItemTypeWidth;
}

- (void)addAnnotationFromSubtype:(PDFAnnotationSubtype)subtype withMarkUpType:(PDFMarkupType)markUp {
    for (PDFSelection *lineSelection in self.pdfDocumentView.currentSelection.selectionsByLine.copy) {
        PDFAnnotation *annotation = [[PDFAnnotation alloc] initWithBounds:[lineSelection boundsForPage:self.pdfDocumentView.currentPage] forType:subtype withProperties:nil];
        [annotation setMarkupType:markUp];
        [annotation setColor:[UIColor redColor]];
        [self.pdfDocumentView.currentPage addAnnotation:annotation];
    }
}

- (void)undoAnnotation {
    PDFAnnotation *lastAnnotation = [self.pdfDocumentView.currentPage.annotations lastObject];
    if (lastAnnotation) {
        [self.pdfDocumentView.currentPage removeAnnotation:lastAnnotation];
        [self.removedAnnotations addObject:lastAnnotation];
    }
}

- (void)redoAnnotation {
    PDFAnnotation *lastRemovedAnnotation = [self.removedAnnotations lastObject];
    if (lastRemovedAnnotation) {
        [self.removedAnnotations removeLastObject];
        [self.pdfDocumentView.currentPage addAnnotation:lastRemovedAnnotation];
    }
}

- (void)didChooseOption:(NSUInteger)option forItem:(ToolboxItemType)itemType {
    if (itemType == ToolboxItemTypeColor) {
        self.previouslyPressed.backgroundColor = self.
    }
    self.itemOption = option;
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
    self.path = [UIBezierPath bezierPath];
    [self.path moveToPoint:self.lastPoint];
    self.isAnnotationAdded = false;
    self.lastPoint = point;
}

- (void)drawingOfAnnotationContinuedAtPoint:(CGPoint)point {
    if (self.previouslyPressed.tag == ToolboxItemTypeArrow) {
        [self removeAnnotationIfNeededWithPoint:self.lastPoint];
        
        CGRect annotationBounds = [self.pdfDocumentView.currentPage boundsForBox:kPDFDisplayBoxMediaBox];
        self.annotation = [[PDFAnnotation alloc] initWithBounds:annotationBounds forType:PDFAnnotationSubtypeLine withProperties:nil];
        self.annotation.startPoint = self.lastPoint;
        self.annotation.endPoint = point;
        self.annotation.endLineStyle = kPDFLineStyleClosedArrow;
        [self.pdfDocumentView.currentPage addAnnotation:self.annotation];
    }
    else {
        [self drawingOfAnnotationWithBezierPathContinuedAtPoint:point];
    }
}

- (void)drawingOfAnnotationWithBezierPathContinuedAtPoint:(CGPoint)point {
    [self updateBezierPathWithPoint:point];
    [self removeAnnotationIfNeededWithPoint:point];
    [self addAnnotationWithCurrentBezierPath];
}

-(void)removeAnnotationIfNeededWithPoint:(CGPoint)point {
    if (self.isAnnotationAdded) {
        [self.pdfDocumentView.currentPage removeAnnotation:self.annotation];
    }
    else {
        self.lastPoint = point;
        self.isAnnotationAdded = true;
    }
}

- (void)updateBezierPathWithPoint:(CGPoint)point {
    if (self.previouslyPressed.tag == ToolboxItemTypePen) {
        [self.path addLineToPoint:point];
    }
    else if (self.previouslyPressed.tag == ToolboxItemTypeShape) {
        [self drawShapeFromType:self.itemOption atPoint:point];
    }
}

- (void)drawShapeFromType:(ShapeType)shapeType atPoint:(CGPoint)point {
    CGFloat beginPointX = MIN(self.lastPoint.x, point.x);
    CGFloat beginPointY = MIN(self.lastPoint.y, point.y);
    CGFloat endPointX = MAX(self.lastPoint.x, point.x);
    CGFloat endPointY = MAX(self.lastPoint.y, point.y);
    CGFloat width = endPointX - beginPointX;
    CGFloat height = endPointY - beginPointY;
    
    CGRect shapeRect = CGRectMake(beginPointX, beginPointY, width, height);
    
    if (shapeType == ShapeTypeRegularRectangle) {
        self.path = [UIBezierPath bezierPathWithRect:shapeRect];
    }
    else if (shapeType == ShapeTypeCircle) {
        self.path = [UIBezierPath bezierPathWithOvalInRect:shapeRect];
    }
    else if (shapeType == ShapeTypeRoundedRectangle) {
        self.path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:5.0];
    }
}

- (void)drawingOfAnnotationEndedAtPoint:(CGPoint)point {
    if (self.previouslyPressed.tag == ToolboxItemTypePen) {
        [self.path addLineToPoint:point];
    }
    if (self.previouslyPressed.tag != ToolboxItemTypeArrow) {
        [self.pdfDocumentView.currentPage removeAnnotation:self.annotation];
        [self addAnnotationWithCurrentBezierPath];
    }
}

- (void)addAnnotationWithCurrentBezierPath {
    CGRect annotationBounds = [self.pdfDocumentView.currentPage boundsForBox:kPDFDisplayBoxMediaBox];
    self.annotation = [[PDFAnnotation alloc] initWithBounds:annotationBounds forType:PDFAnnotationSubtypeInk withProperties:nil];
    self.annotation.color = [UIColor orangeColor];
    [self.annotation addBezierPath:self.path];
    [self.pdfDocumentView.currentPage addAnnotation:self.annotation];
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
