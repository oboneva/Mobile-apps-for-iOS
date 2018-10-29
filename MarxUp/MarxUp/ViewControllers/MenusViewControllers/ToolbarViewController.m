//
//  ToolbarViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 24.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ToolbarViewController.h"

@interface ToolbarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *toolboxButton;

@end

@implementation ToolbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self annotationRelatedButtonsSetHidden:YES];
}

- (void)annotationRelatedButtonsSetHidden:(BOOL)hidden {
    [self.saveButton setHidden:hidden];
    [self.resetButton setHidden:hidden];
    [self.toolboxButton setHidden:hidden];
}

- (IBAction)onAnnotateTap:(id)sender {
    [self annotationRelatedButtonsSetHidden:NO];
    [self.toolbarButtonsDelegate didSelectAnnotate];
}

- (IBAction)onSaveTap:(id)sender {
    [self.toolbarButtonsDelegate didSelectSave];
}

- (IBAction)onResetTap:(id)sender {
    [self.toolbarButtonsDelegate didSelectReset];
}

- (IBAction)onToolboxTap:(id)sender {
    [self.toolbarButtonsDelegate didSelectToolbox];
}

@end
