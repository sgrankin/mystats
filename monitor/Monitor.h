//
//  Monitor.h
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Monitor : NSObject
- (void)run; ///< Run the main loop.

@property(nonatomic) NSURL *outputDirectory; ///< Defaults to current working directory.
@property(nonatomic) BOOL verbose; ///< Enable verbose logging.
@end
