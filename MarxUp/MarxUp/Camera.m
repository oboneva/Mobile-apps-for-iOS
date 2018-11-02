//
//  Camera.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 1.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "Camera.h"
#import "FileManager.h"
#import <AVFoundation/AVFoundation.h>

@interface Camera ()

@property (strong, nonatomic) AVCaptureSession *photoCaptureSession;

@property (strong, nonatomic) AVCaptureDevice *frontCamera;
@property (strong, nonatomic) AVCaptureDevice *backCamera;

@property (strong, nonatomic) AVCaptureDeviceInput *frontCameraInput;
@property (strong, nonatomic) AVCaptureDeviceInput *backCameraInput;

@property (strong, nonatomic) AVCapturePhotoOutput *photoOutput;

@property (assign) AVCaptureDevicePosition currentPosition;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation Camera

+ (instancetype)newCameraWithOutputView:(UIView *)outputView {
    Camera *new = [Camera new];
    new.photoCaptureSession = [AVCaptureSession new];
    [new.photoCaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    new.currentPosition = AVCaptureDevicePositionBack;

    new.frontCameraInput = [new defaultFrontCameraInput];
    new.backCameraInput = [new defaultBackCameraInput];
    [new configSessionWithCurrentDeviceInput];

    new.photoOutput = [new defaultOutput];
    [new.photoCaptureSession addOutput:new.photoOutput];

    [new configOutputToView:outputView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [new.photoCaptureSession startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            new.previewLayer.frame = outputView.bounds;
        });
    });
    
    return new;
}

- (AVCaptureDeviceInput *)defaultFrontCameraInput {
    AVCaptureDevice *frontCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    [frontCamera lockForConfiguration:nil];
    if ([frontCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            frontCamera.focusMode = AVCaptureFocusModeAutoFocus;
    }
    [frontCamera unlockForConfiguration];
    return [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:nil];
}

- (AVCaptureDeviceInput *)defaultBackCameraInput {
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    [backCamera lockForConfiguration:nil];
    if ([backCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            backCamera.focusMode = AVCaptureFocusModeAutoFocus;
    }
    [backCamera unlockForConfiguration];
    return [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
}

- (AVCapturePhotoOutput *)defaultOutput {
    AVCapturePhotoOutput *output = [AVCapturePhotoOutput new];
    [output setHighResolutionCaptureEnabled:YES];
    [output setLivePhotoCaptureEnabled:NO];
    
    return output;
}

- (void)configSessionWithCurrentDeviceInput {
    if (self.currentPosition == EnumCameraFront) {
        [self.photoCaptureSession addInput:self.frontCameraInput];
    }
    else {
        [self.photoCaptureSession addInput:self.backCameraInput];
    }
}

- (void)configOutputToView:(UIView *)view {
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.photoCaptureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [view.layer addSublayer:self.previewLayer];
}

- (EnumCamera)currentCamera {
    if (self.currentPosition == AVCaptureDevicePositionFront) {
        return EnumCameraFront;
    }
    return EnumCameraBack;
}

- (void)switchCamera {
    if (self.currentPosition == AVCaptureDevicePositionFront) {
        self.currentPosition = AVCaptureDevicePositionBack;
        [self.photoCaptureSession removeInput:self.frontCameraInput];
        [self.photoCaptureSession addInput:self.backCameraInput];
    }
    else {
        self.currentPosition = AVCaptureDevicePositionFront;
        [self.photoCaptureSession removeInput:self.backCameraInput];
        [self.photoCaptureSession addInput:self.frontCameraInput];
    }
}

- (void)takePhoto {
    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings new];
    [photoSettings setHighResolutionPhotoEnabled:YES];
    [photoSettings setFlashMode:AVCaptureFlashModeOff];
    [photoSettings setAutoStillImageStabilizationEnabled:YES];
    [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
}

- (void)stopCamera {
    [self.photoCaptureSession stopRunning];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData *imageData = [photo fileDataRepresentation];
    [FileManager saveImage:imageData atImageURL:nil];
}

@end
