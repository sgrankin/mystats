//
//  main.m
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monitor.h"

int main(int argc, const char * argv[])
{
  @autoreleasepool {
    [[Monitor new] run];
  }
  return 0;
}

