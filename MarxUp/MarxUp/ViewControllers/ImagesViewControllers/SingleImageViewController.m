//
//  SingleImageViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 19.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "SingleImageViewController.h"
#import "ToolbarViewController.h"
#import "ToolboxViewController.h"

#import "FileManager.h"
#import "Annotator.h"
#import "ToolboxInitializer.h"

#import "Utilities.h"

@interface SingleImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIView *toolboxView;
@property (strong, nonatomic) Annotator *annotator;

@end

@implementation SingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    
    [self addGestureRecognizers];
    
    self.annotator = [Annotator newForAnnotatingImage:self.imageView];
    for (UIViewController *childController in self.childViewControllers) {
        if ([childController isKindOfClass:ToolboxViewController.class]) {
            ToolboxViewController *toolboxController = (ToolboxViewController *)childController;
            toolboxController.toolboxItemDelegate = self.annotator;
            toolboxController.editedContentStateDelegate = self.annotator;
        }
    }

    [self.toolboxView setHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:ToolbarViewController.class]) {
        ToolbarViewController *toolbarController = segue.destinationViewController;
        toolbarController.toolbarButtonsDelegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:ToolboxViewController.class]) {
        ToolboxViewController *toolboxController = segue.destinationViewController;
        toolboxController.buttonsForContentType = ContentTypeImage;
        self.toolboxView = toolboxController.view;
    }
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGestureRecognizer:)];
    panGestureRecognizer.delegate = self;
    [self.imageView addGestureRecognizer:panGestureRecognizer];
}

- (void)handleTap {
    [self.toolboxView setHidden:YES];
}

- (void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.imageView];
    point = [Utilities convertPoint:point fromViewWithSize:self.imageView.frame.size andContentInAspectFitModeWithSize:self.imageView.image.size];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.annotator beginAnnotatingAtPoint:point];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.annotator endAnnotatingAtPoint:point];
    }
    else {
        [self.annotator continueAnnotatingAtPoint:point];
    }
}

- (void)didSelectAnnotate {
    [self.imageView setUserInteractionEnabled:YES];
}

- (void)didSelectSave {
    NSData *data = UIImagePNGRepresentation(self.imageView.image);
    [FileManager saveImage:data atImageURL:self.imageURL];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectReset {
    [self.annotator reset];
}

- (void)didSelectToolbox {
    [self.toolboxView setHidden:![self.toolboxView isHidden]];
}


@end
