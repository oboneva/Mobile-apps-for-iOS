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
#import "Utilities.h"

@interface PhotoCaptureViewController ()

@property (strong, nonatomic) IBOutlet UIView *photoPreviewView;

@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (strong, nonatomic) Camera *camera;

@end

@implementation PhotoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.switchCameraButton setImage:[UIImage imageNamed:[Utilities frontCameraIcon]] forState:UIControlStateNormal];
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
    if (self.camera.currentCamera == EnumCameraBack) {
        buttonImage = [UIImage imageNamed:[Utilities frontCameraIcon]];
    }
    else {
        buttonImage = [UIImage imageNamed:[Utilities backCameraIcon]];
    }
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    [self.camera switchCamera];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.camera updateOrientationWithView:self.photoPreviewView];
}

@end
