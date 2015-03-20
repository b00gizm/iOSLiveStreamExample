//
//  ViewController.m
//  LiveStreamTest
//
//  Created by Pascal Cremer on 19.03.15.
//  Copyright (c) 2015 Pascal Cremer. All rights reserved.
//

#import <VideoToolbox/VideoToolbox.h>
#import "RtmpWrapper.h"

#import "ViewController.h"

@interface ViewController () {
    AVCaptureDevice *_device;
    RtmpWrapper *_rtmp;
}

@end

static ViewController *vcPointer = nil;

void OutputCallback(void *outputCallbackRefCon,
                void *sourceFrameRefCon,
                OSStatus status,
                VTEncodeInfoFlags infoFlags,
                CMSampleBufferRef sampleBuffer) {
    
    /*
    if (infoFlags & kVTEncodeInfo_Asynchronous) {
        NSLog(@"Asynchronous!");
    }
    if (infoFlags & kVTEncodeInfo_FrameDropped) {
        NSLog(@"Frame dropped!");
    }
    */
    
    if (status == noErr) {
        return [vcPointer didReceiveSampleBuffer:sampleBuffer];
    }
    
    NSLog(@"Error: %@", [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil]);
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    vcPointer = self;
    
    //_rtmp = [[RtmpWrapper alloc] init];
    //[_rtmp openWithURL:@"rtmp://123.123.123.123" enableWrite:YES];
    
    NSArray *devices = [AVCaptureDevice devices];
    [devices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AVCaptureDevice *device = (AVCaptureDevice *)obj;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            _device = device;
            *stop = YES;
        }
    }];
    
    if (!_device) {
        NSLog(@"No device found!");
    } else {
        [self startRecording];
    }
}

- (void)startRecording {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (!input) {
        NSLog(@"Error: %@", error.localizedDescription);
        
        return;
    }
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    output.videoSettings = @{
                             (NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)
                             };
    dispatch_queue_t queue = dispatch_queue_create("co.codenugget.iOSLiveStreamExample.OutputQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    [captureSession addInput:input];
    [captureSession addOutput:output];
    
    AVCaptureVideoPreviewLayer *preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    preview.frame = self.view.frame;
    preview.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:preview];
    
    [captureSession startRunning];
}

- (void)didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!sampleBuffer) {
        return;
    }

    CMBlockBufferRef block = CMSampleBufferGetDataBuffer(sampleBuffer);
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, false);
    CFDictionaryRef attachment = (CFDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
    CFBooleanRef dependsOnOthers = (CFBooleanRef)CFDictionaryGetValue(attachment, kCMSampleAttachmentKey_DependsOnOthers);
    bool isKeyframe = (dependsOnOthers == kCFBooleanFalse);
    if (isKeyframe) {
        char* bufferData;
        size_t size;
        CMBlockBufferGetDataPointer(block, 0, NULL, &size, &bufferData);
        
        NSData *data = [NSData dataWithBytes:bufferData length:size];
        
        // Now what?
    }
}

#pragma AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    //CVPixelBufferLockBaseAddress(imageBuffer, 0);
    //void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    //size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    //NSLog(@"width: %lu - height: %lu\n", width, height);
    
    VTCompressionSessionRef session;
    OSStatus ret = VTCompressionSessionCreate(NULL, (int)width, (int)height, kCMVideoCodecType_H264, NULL, NULL, NULL, OutputCallback, NULL, &session);
    if (ret == noErr) {
        VTSessionSetProperty(session, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        
        CMTime presentationTimestamp = CMTimeMake(0, 1);
        VTCompressionSessionEncodeFrame(session, imageBuffer, presentationTimestamp, kCMTimeInvalid, NULL, NULL, NULL);
        VTCompressionSessionEndPass(session, false, NULL);
    }
    
    if (session) {
        VTCompressionSessionInvalidate(session);
        CFRelease(session);
    }
}

//- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"captureOutput:didDropSampleBuffer:fromConnection");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
