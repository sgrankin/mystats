//
//  CameraMonitor.m
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import "CameraMonitor.h"

#import <AVFoundation/AVFoundation.h>

@interface CameraMonitor ()
{
    AVCaptureSession *_captureSession;
    AVCaptureStillImageOutput *_stillOutput;
}

@end

@implementation CameraMonitor
- (instancetype)initWithOutputDirectoryURL:(NSURL *)outputDirectory
{
    if (self = [super initWithOutputDirectoryURL:outputDirectory]) {
        
        _captureSession = [AVCaptureSession new];
        [_captureSession beginConfiguration];
        _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:nil];
        if (!cameraInput)
            return nil;
        [_captureSession addInput:cameraInput];
        
        _stillOutput = [AVCaptureStillImageOutput new];
        [_captureSession addOutput:_stillOutput];
        
        [_captureSession commitConfiguration];
    }
    return self;
}

- (void)execute
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.jpeg", [NSHost currentHost].localizedName, [df stringFromDate:[NSDate date]]];
    NSURL *outputURL = [self.outputDirectory URLByAppendingPathComponent:fileName];
    
    [_captureSession startRunning];
    [_stillOutput captureStillImageAsynchronouslyFromConnection:[_stillOutput connectionWithMediaType:AVMediaTypeVideo]
                                              completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         if (imageDataSampleBuffer)
             CFRetain(imageDataSampleBuffer);
         
         // No touching the capture session on the callback queue.
         dispatch_async(dispatch_get_main_queue(), ^{
             [_captureSession stopRunning];
             if (imageDataSampleBuffer) {
                 NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                 CFRelease(imageDataSampleBuffer);
                 [[NSFileManager defaultManager] createDirectoryAtURL:self.outputDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                 [data writeToURL:outputURL atomically:YES];
             }
         });
     }];
}

@end
