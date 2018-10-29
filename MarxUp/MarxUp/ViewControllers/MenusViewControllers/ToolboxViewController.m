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

#import "ToolboxInitializer.h"

@interface ToolboxViewController ()

@property (strong, nonatomic)UIButton *previouslyPressed;

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
    if (item.tag == ToolboxItemTypeWidth) {
        LineWidthViewController *lineWidthControler = (LineWidthViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:ID_LINE_WIDTH_VIEW_CONTROLLER];
        lineWidthControler.toolboxItemDelegate = self.toolboxItemDelegate;
        viewController = lineWidthControler;
    }
    else {
        ToolboxItemViewController *itemCollectionViewController = (ToolboxItemViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:ID_TOOLBOX_ITEM_VIEW_CONTROLLER];
        itemCollectionViewController.itemType = item.tag;
        itemCollectionViewController.toolboxItemDelegate = self.toolboxItemDelegate;
        viewController = itemCollectionViewController;
    }
    
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    viewController.popoverPresentationController.delegate = self;
    viewController.popoverPresentationController.sourceView = self.view;
    viewController.popoverPresentationController.sourceRect = item.frame;
    viewController.preferredContentSize = CGSizeMake(100, 150);
    
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
