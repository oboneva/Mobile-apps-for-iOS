//
//  PhotoCaptureViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 1.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "PhotoCaptureViewController.h"

#import "Camera.h"
#import "Constants.h"

#define CAMERA_FRONT  @"camera_front_icon"
#define CAMERA_BACK   @"camera_back_icon"

@interface PhotoCaptureViewController ()

@property (strong, nonatomic) IBOutlet UIView *photoPreviewView;

@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;


@property (strong, nonatomic) Camera *camera;

@end

@implementation PhotoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.switchCameraButton setImage:[UIImage imageNamed:CAMERA_FRONT] forState:UIControlStateNormal];
    self.camera = [Camera newCameraWithOutputView:self.photoPreviewView];
    [self.view bringSubviewToFront:self.switchCameraButton];
    [self.view bringSubviewToFront:self.takePhotoButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.camera stopCamera];
}

- (IBAction)onTakePhotoTap:(id)sender {
    [self.camera takePhoto];
}

- (IBAction)onSwitchCameraTap:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIImage *buttonImage;
    if ([self.camera currentCamera] == EnumCameraBack) {
        buttonImage = [UIImage imageNamed:CAMERA_FRONT];
    }
    else {
        buttonImage = [UIImage imageNamed:CAMERA_BACK];
    }
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    [self.camera switchCamera];
}

@end
