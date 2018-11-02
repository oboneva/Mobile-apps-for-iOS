//
//  Camera.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 1.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface Camera : NSObject <AVCapturePhotoCaptureDelegate>

+ (instancetype)newCameraWithOutputView:(UIView *)outputView;

- (EnumCamera)currentCamera;
- (void)switchCamera;
- (void)takePhoto;
- (void)stopCamera;
- (void)updateOrientationWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
