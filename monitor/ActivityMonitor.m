//
//  ActivityMonitor.m
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import "ActivityMonitor.h"

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
    
//    -
//date: `date +%FT%T%z`
//idle: $((`/usr/sbin/ioreg -c IOHIDSystem | sed -e '/HIDIdleTime/!{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'` / 1000000000 ))
//foreground_app: `/usr/bin/osascript -e 'tell application "System Events"' -e 'set frontApp to name of first application process whose frontmost is true' -e 'end tell'`
//    EOF
//    if [ 0 -lt `osascript -e 'tell application "System Events" to count (processes whose name is "itunes")'` ]; then
//    cat <<EOF >> $FILE
//itunes:
//state: `osascript -e 'tell application "iTunes" to player state as string'`
//    EOF
//    if [ "playing" = "$(osascript -e 'tell application "iTunes" to player state as string')" ]; then
//    cat <<EOF >> $FILE
//artist: `osascript -e 'tell application "iTunes" to artist of current track'`
//album: `osascript -e 'tell application "iTunes" to album of current track'`
//title: `osascript -e 'tell application "iTunes" to name of current track'`

}


@end
