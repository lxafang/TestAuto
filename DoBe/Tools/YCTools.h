//
//  YCTools.h
//  iBusDriver
//
//  Created by liuxuan on 15/3/10.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCTools : NSObject

+ (NSArray *)returnArray:(NSArray *)array;

+ (NSDictionary *)returnDictionary:(NSDictionary *)params;

+ (NSString *)dateStringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)dateStartTimeWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)dateNoYearStringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)timeStringWithFullDate:(NSDate *)date;

+ (NSString *)timeStringWithFormat:(NSDate *)date;

+ (NSDate *)getDateWithTimeString:(NSString *)timeString;

+ (NSString *)timeStringTotimeStamp:(NSTimeInterval)toTime  from:(NSTimeInterval)fromTime;

+ (NSTimeInterval)timeIntervalWithTimeString:(NSString *)timeString;

+ (NSTimeInterval)timeInterValWithDateInterVal:(NSTimeInterval)dateInt withHourString:(NSString *)hourString;

+ (NSString *)formatStartTime:(double)timeString;
+ (NSString *)formatEndTime:(double)timeString;


@end
