//
//  LFLocationTraceManager.m
//  LocationFrobber
//
//  Created by Mark Pirri on 8/21/12.
//  Copyright (c) 2012 Mark Pirri. All rights reserved.
//

#import "LFLocationTraceManager.h"

@interface LFLocationTraceManager ()

@property(nonatomic,assign) BOOL isLoggingLocation;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) LFLocationTrace *locationTrace;

@end

@implementation LFLocationTraceManager

+ (LFLocationTraceManager *)sharedInstance
{
    static LFLocationTraceManager *s_instance = nil;
    
    if (nil == s_instance) {
        s_instance = [[[self class] alloc] init];
    }
    
    return s_instance;
}

- (id)init
{
    self = [super init];
    if (nil != self) {
        _locationTrace = [[LFLocationTrace alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

- (void)startLoggingLocation
{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.isLoggingLocation = YES;
}

- (void)stopLoggingLocation
{
    [self.locationManager stopUpdatingLocation];
    self.isLoggingLocation = NO;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.locationTrace saveTrace:newLocation forDate:[NSDate date]];
}

@end
