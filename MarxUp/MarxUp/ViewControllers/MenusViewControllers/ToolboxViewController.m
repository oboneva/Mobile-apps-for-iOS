//
//  ToolboxViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 24.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ToolboxViewController.h"
#import "LineWidthViewController.h"
#import "ToolboxItemViewcontroller.h"
#import "ColorPickerViewController.h"

#import "ToolboxInitializer.h"
#import "Utilities.h"

@interface ToolboxViewController ()

@property (strong, nonatomic) UIButton *previouslyPressed;

@end

@implementation ToolboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ToolboxInitializer *initializer = [ToolboxInitializer newToolboxInitializerForViewWithContentType:self.buttonsForContentType];
    [initializer addToolboxItemsToView:(UIScrollView *)self.view withTarget:self andSelector:@selector(toolboxItemPressed:)];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)toolboxItemPressed:(UIButton *)button {
    if (button.tag == ToolboxItemTypeUndo) {
        [self.editedContentStateDelegate didSelectUndo];
    }
    else if (button.tag == ToolboxItemTypeRedo) {
        [self.editedContentStateDelegate didSelectRedo];
    }
    else if (button.tag == ToolboxItemTypePen) {
        [self.toolboxItemDelegate didChoosePen];
    }
    else if (button.tag == ToolboxItemTypeTextUnderline ||
             button.tag == ToolboxItemTypeTextStrikeThrough ||
             button.tag == ToolboxItemTypeTextHighlight) {
        [self.toolboxItemDelegate didChooseTextAnnotationFromType:button.tag];
    }
    else if ([self shouldPresentOptionsForButton:button]) {
        [self presentOptionsForToolboxItem:button];
    }
}

- (BOOL)shouldPresentOptionsForButton:(UIButton *)button {
    return button.tag == ToolboxItemTypeArrow || button.tag == ToolboxItemTypeColor || button.tag == ToolboxItemTypeShape || button.tag == ToolboxItemTypeWidth;
}

- (void)presentOptionsForToolboxItem:(UIButton *)item {
    UIViewController *viewController;
    CGSize contentSize = CGSizeMake(100, 150);
    if (item.tag == ToolboxItemTypeWidth) {
        LineWidthViewController *lineWidthControler = (LineWidthViewController *)[Utilities viewControllerWithClass:LineWidthViewController.class];
        lineWidthControler.toolboxItemDelegate = self.toolboxItemDelegate;
        viewController = lineWidthControler;
    }
    else if (item.tag == ToolboxItemTypeColor) {
        ColorPickerViewController *colorPickerController = (ColorPickerViewController *)[Utilities viewControllerWithClass:ColorPickerViewController.class];
        colorPickerController.toolboxItemDelegate = self.toolboxItemDelegate;
        viewController = colorPickerController;
        contentSize = CGSizeMake(220, 220);
    }
    else {
        ToolboxItemViewController *itemCollectionViewController = (ToolboxItemViewController *)[Utilities viewControllerWithClass:ToolboxItemViewController.class];
        itemCollectionViewController.itemType = item.tag;
        itemCollectionViewController.toolboxItemDelegate = self.toolboxItemDelegate;
        viewController = itemCollectionViewController;
    }
    
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    viewController.popoverPresentationController.delegate = self;
    viewController.popoverPresentationController.sourceView = self.view;
    viewController.popoverPresentationController.sourceRect = item.frame;
    viewController.preferredContentSize = contentSize;
    
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
