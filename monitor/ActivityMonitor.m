//
//  ActivityMonitor.m
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import "ActivityMonitor.h"
// --
#import <IOKit/IOKitLib.h>
#import "YAML/YAMLSerialization.h"
// --
#import "iTunes.h"
#import "SystemEvents.h"

@implementation ActivityMonitor

- (instancetype)initWithOutputDirectoryURL:(NSURL *)outputDirectory
{
  if (self = [super initWithOutputDirectoryURL:outputDirectory]) {
  }
  return self;
}

- (void)execute
{
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"yyyy-MM-dd";
  df.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
  NSString *fileName = [NSString stringWithFormat:@"%@-%@.yml", [NSHost currentHost].localizedName, [df stringFromDate:[NSDate date]]];
  NSURL *outputURL = [self.outputDirectory URLByAppendingPathComponent:fileName];
  
  NSData *yaml = [YAMLSerialization dataFromYAML:@[[self activity]] options:kYAMLWriteOptionFragment error:nil];
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:outputURL.path])
    [[NSFileManager defaultManager] createFileAtPath:outputURL.path contents:nil attributes:nil];
  
  NSError *error;
  NSFileHandle *file = [NSFileHandle fileHandleForUpdatingURL:outputURL error:&error];
  if (!file) {
    NSLog(@"%@ Failed to open file %@ for writing: %@ #Error", self.class, outputURL, error.localizedDescription);
    return;
  }
  [file seekToEndOfFile];
  [file writeData:yaml];
  [file closeFile];
}

- (NSDictionary *)activity
{
  NSMutableDictionary *activity = [NSMutableDictionary new];
  
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
  activity[@"date"] = [df stringFromDate:[NSDate new]];
  activity[@"idle"] = @([self idleTime]);
  
  SystemEventsApplication *systemEvents = [SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"];
  NSArray *apps = [systemEvents.applicationProcesses.get filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SystemEventsApplication *app, NSDictionary *bindings) {
    return app.frontmost;
  }]];
  if (apps.count)
    activity[@"foreground_app"] = [apps[0] name];
  
  iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
  if (iTunes.isRunning) {
    NSMutableDictionary *iTunesActivity = [NSMutableDictionary new];
    iTunesActivity[@"state"] = [self stringFromItunesPlayerState:iTunes.playerState];
    if (iTunes.playerState == iTunesEPlSPlaying) {
      iTunesTrack *track = iTunes.currentTrack;
      iTunesActivity[@"artist"] = track.artist;
      iTunesActivity[@"album"] = track.album;
      iTunesActivity[@"title"] = track.name;
    }
    activity[@"itunes"] = iTunesActivity;
  }
  return activity;
}

- (NSString *)stringFromItunesPlayerState:(iTunesEPlS)playerState
{
  switch (playerState) {
    case iTunesEPlSFastForwarding: return @"fastforwarding";
    case iTunesEPlSPaused: return @"paused";
    case iTunesEPlSPlaying: return @"playing";
    case iTunesEPlSRewinding: return @"rewinding";
    case iTunesEPlSStopped: return @"stopped";
  }
}

- (int64_t)idleTime
{
  int64_t idlesecs = -1;
  io_iterator_t iter = 0;
  if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IOHIDSystem"), &iter) == KERN_SUCCESS) {
    io_registry_entry_t entry = IOIteratorNext(iter);
    if (entry) {
      CFMutableDictionaryRef dict = NULL;
      if (IORegistryEntryCreateCFProperties(entry, &dict, kCFAllocatorDefault, 0) == KERN_SUCCESS) {
        CFNumberRef obj = CFDictionaryGetValue(dict, CFSTR("HIDIdleTime"));
        if (obj) {
          int64_t nanoseconds = 0;
          if (CFNumberGetValue(obj, kCFNumberSInt64Type, &nanoseconds)) {
            idlesecs = nanoseconds / 1000000000ll; // Divide by 10^9 to convert from nanoseconds to seconds.
          }
        }
        CFRelease(dict);
      }
      IOObjectRelease(entry);
    }
    IOObjectRelease(iter);
  }
  return idlesecs;
}


@end
