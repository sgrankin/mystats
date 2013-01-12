//
//  BasicMonitor.h
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMonitor : NSObject
/// @param outpxutDirectory Where to write any generated files.
- (instancetype)initWithOutputDirectoryURL:(NSURL *)outputDirectory;

/// Called periodically by the main loop.
/// Subclasses should override this method to do their activities.
- (void)execute;

@property (readonly) NSURL *outputDirectory;
@end
