//
//  BasicMonitor.m
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import "BasicMonitor.h"

@interface BasicMonitor ()
{
    NSURL *_outputDirectory;
}

@end

@implementation BasicMonitor
- (id)init
{
    return ([self doesNotRecognizeSelector:_cmd], nil);
}

- (instancetype)initWithOutputDirectoryURL:(NSURL *)outputDirectory
{
    if (self = [super init]) {
        _outputDirectory = outputDirectory;
        [[NSFileManager defaultManager] createDirectoryAtURL:_outputDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}

- (void)execute
{
    // NOP
}
@end
