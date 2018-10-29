//
//  Protocols.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 28.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#ifndef Protocols_h
#define Protocols_h

#import "Constants.h"

//@protocol ToolboxItemOptionsDelegate <NSObject>
//
//- (void)didChooseOption:(NSInteger)option forItem:(ToolboxItemType)itemType;
//- (void)didChooseColor:(UIColor *)color;
//- (void)didChooseLineWidth:(CGFloat)width;
//
//@end

@protocol ToolboxItemDelegate <NSObject>

- (void)didChooseTextAnnotationFromType:(ToolboxItemType)type;
- (void)didChoosePen;
- (void)didChooseOption:(NSInteger)option forType:(ToolboxItemType)itemType;
- (void)didChooseColor:(UIColor *)color;
- (void)didChooseLineWidth:(CGFloat)width;

@end

@protocol ToolbarButtonsDelegate <NSObject>

- (void)didSelectAnnotate;
- (void)didSelectSave;
- (void)didSelectReset;
- (void)didSelectToolbox;

@end

@protocol EditedContentStateDelegate <NSObject>

- (void)didSelectUndo;
- (void)didSelectRedo;

@end

#endif /* Protocols_h */
