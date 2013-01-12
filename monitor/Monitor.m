//
//  Monitor.m
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import "Monitor.h"
// --
#import "BasicMonitor.h"
#import "CameraMonitor.h"
#import "ActivityMonitor.h"

@interface Monitor ()
{
    NSURL *_outputDirectory;
}

@end

@implementation Monitor
- (instancetype)init
{
    return [self initWithOutputDirectoryURL:[NSURL fileURLWithPath:[NSFileManager defaultManager].currentDirectoryPath]];
}

- (instancetype)initWithOutputDirectoryURL:(NSURL *)outputDirectory
{
    if (self = [super init]) {
        _outputDirectory = outputDirectory;
        NSLog(@"Output Directory %@", _outputDirectory);
    }
    return self;    
}

- (void)scheduleMonitor:(BasicMonitor *)monitor withTimeInterval:(NSTimeInterval)timeInterval
{
    [monitor execute]; // run once
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:monitor selector:@selector(execute) userInfo:nil repeats:YES];
}

- (void)run
{
    CameraMonitor *cameraMonitor = [[CameraMonitor alloc] initWithOutputDirectoryURL:[_outputDirectory URLByAppendingPathComponent:@"headshot"]];
    [self scheduleMonitor:cameraMonitor withTimeInterval:6*60]; // 6 minutes
    
    ActivityMonitor *activityMonitor = [[ActivityMonitor alloc] initWithOutputDirectoryURL:[_outputDirectory URLByAppendingPathComponent:@"activity"]];
    [self scheduleMonitor:activityMonitor withTimeInterval:30];
    
    [[NSRunLoop currentRunLoop] run];
}
@end
