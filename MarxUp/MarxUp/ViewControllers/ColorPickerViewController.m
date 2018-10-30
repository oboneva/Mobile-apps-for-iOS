//
//  ColorPickerViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 29.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ColorPickerViewController.h"

#define COLOR_SECTORS      360
#define DEFAULT_HUE        0.75
#define DEFAULT_SATURATION 1
#define DEFAULT_BRIGHTNESS 1
#define DEFAULT_ALPHA      1
#define COLOR_WHEEL_SIZE   20

@interface ColorPickerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *colorWheelImageView;
@property (strong, nonatomic) UIImageView *pickerImageView;
@property (strong, nonatomic) UIImageView *finalColorImageView;

@property (strong, nonatomic) UIBezierPath *blankSpacePath;
@property (strong, nonatomic) UIBezierPath *finalColorPath;
@property (strong, nonatomic) UIBezierPath *pickerPath;

@property (assign) CGPoint colorWheelCenter;

@property (assign) CGFloat hue;
@property (assign) CGFloat saturation;
@property (assign) CGFloat brightness;

@property (strong, nonatomic) UISlider *saturationSlider;
@property (strong, nonatomic) UISlider *brightnessSlider;

@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    
    [self setUpDefaultColors];
    UIColor *defaultColor = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:DEFAULT_ALPHA];
    
    CGSize size = self.colorWheelImageView.frame.size;
    
    self.colorWheelImageView.image = [self createColorWheelImage];
    self.pickerImageView = [[UIImageView alloc] initWithImage:[self createPickerImageWithColor:defaultColor andSize:CGSizeMake(COLOR_WHEEL_SIZE + 5, COLOR_WHEEL_SIZE + 5)]];
    self.finalColorImageView = [[UIImageView alloc] initWithImage:[self createFinalColorImageWithColor:defaultColor andSize:CGSizeMake((size.width - COLOR_WHEEL_SIZE) / 2.5, (size.height - COLOR_WHEEL_SIZE) / 2.5)]];
    
    [self.colorWheelImageView addSubview:self.pickerImageView];
    self.pickerImageView.center = CGPointMake(size.width / 2, 5);
    [self.colorWheelImageView addSubview:self.finalColorImageView];
    self.finalColorImageView.center = CGPointMake(size.width / 2, size.height / 2);
    
    [self addGestureRecognizers];
    
    [self createSaturationSlider];
    [self createBrightnessSlider];
}

- (void)setUpDefaultColors {
    self.saturation = DEFAULT_SATURATION;
    self.brightness = DEFAULT_BRIGHTNESS;
    self.hue = DEFAULT_HUE;
}

- (void)addGestureRecognizers {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGestureRecognizer:)];
    panRecognizer.delegate = self;
    [self.colorWheelImageView addGestureRecognizer:panRecognizer];
    [self.colorWheelImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapWithGestureRecognizer:)];
    tapRecognizer.delegate = self;
    [self.finalColorImageView addGestureRecognizer:tapRecognizer];
    [self.finalColorImageView setUserInteractionEnabled:YES];
}

- (UIImage *)createColorWheelImage {
    CGSize size = self.colorWheelImageView.frame.size;
    UIGraphicsBeginImageContext(size);
    
    float radius = size.width / 2;
    float angle = 2 * M_PI / COLOR_SECTORS;
    CGPoint center = CGPointMake(size.width / 2, size.height / 2);
    self.colorWheelCenter = center;
    
    UIBezierPath *bezierPath;
    for (int i = 0; i < COLOR_SECTORS; i++) {
        bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:i * angle endAngle:(i + 1) * angle clockwise:YES];
        [bezierPath addLineToPoint:center];
        [bezierPath closePath];
        [self fillAndStrokePath:bezierPath withColor:[UIColor colorWithHue:(float)i / COLOR_SECTORS saturation:DEFAULT_SATURATION brightness:DEFAULT_BRIGHTNESS alpha:DEFAULT_ALPHA]];
    }
    
    UIBezierPath * innerBlankSpace = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(COLOR_WHEEL_SIZE / 2, COLOR_WHEEL_SIZE / 2, size.width - COLOR_WHEEL_SIZE, size.height - COLOR_WHEEL_SIZE)];
    
    [self fillAndStrokePath:innerBlankSpace withColor:UIColor.whiteColor];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.blankSpacePath = innerBlankSpace;
    return image;
}

- (UIImage *)createPickerImageWithColor:(UIColor *)color andSize:(CGSize)size{
    self.pickerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    return [self createImageAndSetItsBezierPath:self.pickerPath size:size andColor:color];
}

- (UIImage *)createFinalColorImageWithColor:(UIColor *)color andSize:(CGSize)size {
    self.finalColorPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    return [self createImageAndSetItsBezierPath:self.finalColorPath size:size andColor:color];
}

- (UIImage *)createImageAndSetItsBezierPath:(UIBezierPath *)path size:(CGSize)size andColor:(UIColor *)color {
    UIGraphicsBeginImageContext(size);
    [self fillAndStrokePath:path withColor:color];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

-(void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.colorWheelImageView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.blankSpacePath containsPoint:point])
        return;
    
    CGFloat dx = point.x - self.colorWheelCenter.x;
    CGFloat dy = point.y - self.colorWheelCenter.y;
    
    self.hue = atan2(dy, dx) / (2 * M_PI) + 1;

    UIColor *color = [UIColor colorWithHue:self.hue saturation:DEFAULT_SATURATION brightness:DEFAULT_BRIGHTNESS alpha:DEFAULT_ALPHA];
    [self setColor:color toImageView:self.finalColorImageView withPath:self.finalColorPath];
    [self setColor:color toImageView:self.pickerImageView withPath:self.pickerPath];
    
    [self updateSlidersColor];

    CGFloat radius = self.colorWheelImageView.image.size.width / 2;
    CGFloat newX = (radius - 5) * cos(atan2(dy, dx)) + self.colorWheelCenter.x;
    CGFloat newY = (radius - 5) * sin(atan2(dy, dx)) + self.colorWheelCenter.y;
    CGPoint newCenter = CGPointMake(newX, newY);
    
    self.pickerImageView.center = newCenter;
}

- (void)handleTapWithGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    [self.toolboxItemDelegate didChooseColor:[UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:DEFAULT_ALPHA]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setColor:(UIColor *)color toImageView:(UIImageView *)imageView withPath:(UIBezierPath *)path {
    UIGraphicsBeginImageContext(imageView.frame.size);
    [self fillAndStrokePath:path withColor:color];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)createSaturationSlider {
    self.saturationSlider = [UISlider new];
    [self setUpSlider:self.saturationSlider withValue:self.saturation andAction:@selector(didChangeSaturationSlider)];
    
    [self.colorWheelImageView addSubview:self.saturationSlider];
    self.saturationSlider.center = CGPointMake(self.colorWheelCenter.x, self.colorWheelCenter.y * 0.5);
}

- (void)didChangeSaturationSlider {
    self.saturation = self.saturationSlider.value;
    [self.saturationSlider setThumbTintColor:[UIColor colorWithHue:self.hue saturation:self.saturation brightness:DEFAULT_BRIGHTNESS alpha:DEFAULT_ALPHA]];
    [self setColor:[UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:DEFAULT_ALPHA] toImageView:self.finalColorImageView withPath:self.finalColorPath];
}

- (void)createBrightnessSlider {
    self.brightnessSlider = [UISlider new];
    [self setUpSlider:self.brightnessSlider withValue:self.brightness andAction:@selector(didChangeBrightnessSlider)];
    
    [self.colorWheelImageView addSubview:self.brightnessSlider];
    self.brightnessSlider.center = CGPointMake(self.colorWheelCenter.x, self.colorWheelCenter.y * 1.5 + 2);
}

- (void)didChangeBrightnessSlider {
    self.brightness = self.brightnessSlider.value;
    [self.brightnessSlider setThumbTintColor:[UIColor colorWithHue:self.hue saturation:DEFAULT_SATURATION brightness:self.brightness alpha:DEFAULT_ALPHA]];
    [self setColor:[UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:DEFAULT_ALPHA] toImageView:self.finalColorImageView withPath:self.finalColorPath];
}

- (void)setUpSlider:(UISlider *)slider withValue:(CGFloat)value andAction:(SEL)selector{
    [slider setMinimumValue:0];
    [slider setMaximumValue:1];
    [slider setValue:value];
    
    [slider addTarget:self action:selector forControlEvents:UIControlEventAllEvents];

    [slider setTintColor:[UIColor colorWithHue:self.hue saturation:DEFAULT_SATURATION brightness:DEFAULT_BRIGHTNESS alpha:DEFAULT_ALPHA]];
    [slider setThumbTintColor:[UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:DEFAULT_ALPHA]];
}

- (void)updateSlidersColor {
    UIColor *saturationColor = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:DEFAULT_BRIGHTNESS alpha:DEFAULT_ALPHA];
    [self.saturationSlider setThumbTintColor:saturationColor];
    [self.saturationSlider setTintColor:saturationColor];
    
    UIColor *brightnessColor = [UIColor colorWithHue:self.hue saturation:DEFAULT_SATURATION brightness:self.brightness alpha:DEFAULT_ALPHA];
    [self.brightnessSlider setThumbTintColor:brightnessColor];
    [self.brightnessSlider setTintColor:brightnessColor];
}

- (void)fillAndStrokePath:(UIBezierPath *)path withColor:(UIColor *)color {
    [color setFill];
    [color setStroke];
    [path fill];
    [path stroke];
}


@end
