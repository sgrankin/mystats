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
}
@end

@implementation Monitor
- (instancetype)init
{
  if (self = [super init]) {
    _outputDirectory = [NSURL fileURLWithPath:[NSFileManager defaultManager].currentDirectoryPath];
    _verbose = NO;
  }
  return self;
}

- (void)scheduleMonitor:(BasicMonitor *)monitor withTimeInterval:(NSTimeInterval)timeInterval
{
  if (self.verbose)
    NSLog(@"Adding %@ with interval %f", monitor.class, timeInterval);
  monitor.verbose = self.verbose;
  [monitor execute]; // run once
  [NSTimer scheduledTimerWithTimeInterval:timeInterval target:monitor selector:@selector(execute) userInfo:nil repeats:YES];
}

- (void)run
{
  self.outputDirectory = self.outputDirectory.absoluteURL;
  if (self.verbose)
    NSLog(@"Writing to %@", self.outputDirectory);
  CameraMonitor *cameraMonitor = [[CameraMonitor alloc] initWithOutputDirectoryURL:[_outputDirectory URLByAppendingPathComponent:@"headshot"]];
  [self scheduleMonitor:cameraMonitor withTimeInterval:6*60]; // 6 minutes
  
  ActivityMonitor *activityMonitor = [[ActivityMonitor alloc] initWithOutputDirectoryURL:[_outputDirectory URLByAppendingPathComponent:@"activity"]];
  [self scheduleMonitor:activityMonitor withTimeInterval:30];
  
  [[NSRunLoop currentRunLoop] run];
}
@end
