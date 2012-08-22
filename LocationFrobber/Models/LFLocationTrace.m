//
//  LFLocationTrace.m
//  LocationFrobber
//
//  Created by Mark Pirri on 8/21/12.
//  Copyright (c) 2012 Mark Pirri. All rights reserved.
//

#import "LFLocationTrace.h"

@interface LFLocationTrace ()

@property(strong,nonatomic) NSMutableDictionary *tracesByTime;

@end

@implementation LFLocationTrace

- (NSString *)locationAddedNotificationName
{
    return @"LFLocationTraceLocationAddedNotification";
}

- (id)init
{
    self = [super init];
    if (nil != self) {
        _tracesByTime = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)timeRecords
{
    NSArray *unsortedTimes = [self.tracesByTime allKeys];
    NSArray *sortedTimes = [unsortedTimes sortedArrayUsingSelector:@selector(compare:)];
    return sortedTimes;
}

- (NSArray *)tracesForTime:(NSDate *)inDate
{
    return [self.tracesByTime objectForKey:inDate];
}

- (NSDate *)roundedDateForDate:(NSDate *)inDate
{
    // drop the seconds
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar]
                                        components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                        fromDate:inDate];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}


- (void)saveTrace:(CLLocation *)inLocation forDate:(NSDate *)inDate
{
    NSDate *roundedDate = [self roundedDateForDate:inDate];
    NSMutableArray *mutableTracesForTime = [self.tracesByTime objectForKey:roundedDate];
    if (nil == mutableTracesForTime) {
        mutableTracesForTime = [NSMutableArray array];
        [self.tracesByTime setObject:mutableTracesForTime forKey:roundedDate];
    }
    [mutableTracesForTime addObject:inLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self locationAddedNotificationName] object:self];
}


- (NSString *)prettyTextWhatForMailingToMyBoss
{
    NSMutableString *prettyText = [NSMutableString string];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    
    for (NSDate *time in [self timeRecords]) {
        NSArray *locationTraces = [self tracesForTime:time];
        
        NSString *textStr = [dateFormatter stringFromDate:time];
        
        if ([locationTraces count] > 1) {
            CLLocation *firstLocation = [locationTraces objectAtIndex:0];
            CLLocation *lastLocation = [locationTraces objectAtIndex:[locationTraces count] - 1];
            CLLocationDistance distanceTraveledMetric = [lastLocation distanceFromLocation:firstLocation];
            CLLocationDistance distanceTraveledAmerican = distanceTraveledMetric * 3.28084f;
            textStr = [textStr stringByAppendingFormat:@" (%.1f ft)",floor(distanceTraveledAmerican)];
        }
        
        textStr = [textStr stringByAppendingFormat:@": %d updates",[locationTraces count]];
        
        [prettyText appendFormat:@"%@\n",textStr];
    }
    
    return prettyText;
}

@end
