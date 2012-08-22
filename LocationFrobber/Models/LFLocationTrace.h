//
//  LFLocationTrace.h
//  LocationFrobber
//
//  Created by Mark Pirri on 8/21/12.
//  Copyright (c) 2012 Mark Pirri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LFLocationTrace : NSObject

- (NSString *)locationAddedNotificationName;

- (NSArray *)timeRecords;
- (NSArray *)tracesForTime:(NSDate *)inDate;

- (void)saveTrace:(CLLocation *)inLocation forDate:(NSDate *)inDate;

- (NSString *)prettyTextWhatForMailingToMyBoss;

@end
