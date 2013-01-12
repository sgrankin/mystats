//
//  Monitor.h
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Monitor : NSObject
- (instancetype)initWithOutputDirectoryURL:(NSURL *)outputDirectory;
- (void)run;
@end
