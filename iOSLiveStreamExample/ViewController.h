//
//  ViewController.h
//  LiveStreamTest
//
//  Created by Pascal Cremer on 19.03.15.
//  Copyright (c) 2015 Pascal Cremer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "RtmpWrapper.h"

@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)startRecording;
- (void)didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

