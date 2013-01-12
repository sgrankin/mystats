//
//  main.m
//  monitor
//
//  Created by Sergey Grankin on 2013-01-11.
//  Copyright (c) 2013 Sergey Grankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <getopt.h>
// --
#import "Monitor.h"

void usage(char const * const my_name)
{
  printf("usage: %s [options] [output_directory]\n", my_name);
  printf("options:\n");
  printf("  -t, --help      Be helpful\n");
  printf("  -v, --verbose   Be move verbose\n");
}

int main(int argc, char * const argv[])
{
  @autoreleasepool {
    static struct option longopts[] = {
      {"help",    no_argument, NULL, 'h'},
      {"verbose", no_argument, NULL, 'v'},
      {NULL, 0, NULL, 0},
    };
    
    Monitor *monitor = [Monitor new];
    int opt;
    while ((opt = getopt_long(argc, argv, "hv", longopts, NULL)) != -1) {
      switch (opt) {
        case 'v':
          monitor.verbose = YES;
          break;
        case 'h':
        default:
          usage(argv[0]);
          return 1;
      }
    }
    argc -= optind;
    argv += optind;
    
    if (argc > 1)
      monitor.outputDirectory = [NSURL fileURLWithPath:[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isDirectory:YES];
    
    [monitor run]; // GO!
  }
  return 0;
}

