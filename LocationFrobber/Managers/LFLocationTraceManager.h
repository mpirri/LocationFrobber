//
//  LFLocationTraceManager.h
//  LocationFrobber
//
//  Created by Mark Pirri on 8/21/12.
//  Copyright (c) 2012 Mark Pirri. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import "LFLocationTrace.h"

@interface LFLocationTraceManager : NSObject <CLLocationManagerDelegate>

+ (LFLocationTraceManager *)sharedInstance;

- (LFLocationTrace *)locationTrace;

- (BOOL)isLoggingLocation;
- (void)startLoggingLocation;
- (void)stopLoggingLocation;

@end
