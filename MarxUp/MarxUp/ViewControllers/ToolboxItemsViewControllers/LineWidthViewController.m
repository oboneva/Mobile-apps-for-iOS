//
//  LineWidthViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 2.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "LineWidthViewController.h"

@interface LineWidthViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;

@end

@implementation LineWidthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setImageViewLineWidth:self.widthSlider.value];
}

- (IBAction)onSlide:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [self setImageViewLineWidth:slider.value];
    [self.toolboxItemDelegate didChooseLineWidth:slider.value];
}

- (void)setImageViewLineWidth:(CGFloat)width {
    UIGraphicsBeginImageContext(self.lineImageView.frame.size);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, self.lineImageView.frame.origin.y / 2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lineImageView.frame.size.width, self.lineImageView.frame.origin.y / 2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.lineImageView.image  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
