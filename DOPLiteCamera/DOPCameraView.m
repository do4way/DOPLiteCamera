//
//  DOPCameraView.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/11.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DOPCameraView.h"
#import "DOPCameraFocusSquare.h"

@interface DOPCameraView()

@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) DOPCameraFocusSquare *camFocus;

@end

@implementation DOPCameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCamera];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    [self focus:touchPoint];
    
    if (self.camFocus)
    {
        [self.camFocus removeFromSuperview];
    }
    if ([[touch view] isKindOfClass:[DOPCameraView class]])
    {
        [self showFocusSquare:touchPoint];
    }
}

- (void) autoFocus
{
    [self focus:self.center];
    [self showFocusSquare:self.center];
}

#pragma mark - private method
- (void) setUpCamera
{
    
    NSError *error = nil;
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    //[self.session setSessionPreset:AVCaptureSessionPresetMedium];
    
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    [self.session addInput:self.videoInput];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:captureVideoPreviewLayer];
    
    [self.session startRunning];
    CGPoint center = self.center;
    [self focus:center];
    [self showFocusSquare:center];
    
    
}



- (void)takePhoto:(id)sender
{
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }
    
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                     imageDataSampleBuffer,
                                                                     kCMAttachmentMode_ShouldPropagate);
         NSLog(@"%@",attachments);
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         [library writeImageDataToSavedPhotosAlbum:imageData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
             if (error) {
                NSLog(@"Save to camera roll failed");
             }
         }];
         
         
         if ([self.delegate respondsToSelector : @selector(didImageSaved:)]) {
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             [self.delegate didImageSaved:image];
         }
         
     }];
}

#pragma mark - camera to focus

- (void) focus:(CGPoint) aPoint;
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([device isFocusPointOfInterestSupported] &&
           [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            double screenWidth = screenRect.size.width;
            double screenHeight = screenRect.size.height;
            double focus_x = 1.0f - aPoint.x/screenWidth;
            double focus_y = aPoint.y/screenHeight;
            CGPoint focusPoint = CGPointMake(focus_y, focus_x);
            if([device lockForConfiguration:nil]) {
                [device setFocusPointOfInterest:focusPoint];
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                    [device setExposurePointOfInterest:focusPoint];
                    [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                }
                [device unlockForConfiguration];
            }
        }
    }
}

- (void) showFocusSquare:(CGPoint) point
{
    self.camFocus = [[DOPCameraFocusSquare alloc]initWithFrame:CGRectMake(point.x-40, point.y-40, 80, 80)];
    [self.camFocus setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.camFocus];
    [self.camFocus setNeedsDisplay];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [self.camFocus setAlpha:0.0];
    [UIView commitAnimations];
}

@end
