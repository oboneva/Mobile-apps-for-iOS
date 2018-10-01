//
//  ToolboxInitializer.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 27.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ToolboxInitializer.h"
#import "ToolboxDataSource.h"


@interface ToolboxInitializer ()

@property (strong, nonatomic) ToolboxDataSource *data;

@end


@implementation ToolboxInitializer

+ (instancetype)newToolboxInitializer {
    ToolboxInitializer *new = [ToolboxInitializer new];
    if (new) {
        new.data = [ToolboxDataSource newDataSource];
    }
    return new;
}

- (void)addToolboxItemsToView:(UIScrollView *)toolboxView withTarget:(UIViewController *)targetController andSelector:(SEL)selector {
    int buttonY = 0;
    CGFloat buttonSize = toolboxView.frame.size.width;
    
    for (int i = 0; i < [self.data numberOfToolboxItems]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, buttonSize, buttonSize)];
        [self.data initItemWithButton:button atIndex:i];
        
        [button addTarget:targetController action:selector forControlEvents:UIControlEventTouchUpInside];
        [toolboxView addSubview:button];
        
        buttonY = buttonY + buttonSize;
    }
    
    toolboxView.contentSize = CGSizeMake(toolboxView.frame.size.width, buttonY);
    [ToolboxInitializer configUI:toolboxView];
}

+ (void)configUI:(UIScrollView *)view {
    view.backgroundColor = [UIColor lightGrayColor];
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowRadius = 1.0;
    view.layer.shadowOpacity = 0.5;
    view.layer.borderWidth = 2.0;
}

@end
