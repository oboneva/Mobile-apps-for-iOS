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

@end

@implementation LineWidthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSlide:(id)sender {
    UISlider *slider = (UISlider *)sender;
    UIGraphicsBeginImageContext(self.lineImageView.frame.size);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), slider.value);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, self.lineImageView.frame.origin.y / 2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lineImageView.frame.size.width, self.lineImageView.frame.origin.y / 2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.lineImageView.image  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.toolboxItemOptionsDelegate didChooseLineWidth:slider.value];
}

@end
