//
//  YCTools.m
//  iBusDriver
//
//  Created by liuxuan on 15/3/10.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "YCTools.h"

@implementation YCTools

+ (NSArray *)returnArray:(NSArray *)array {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger index,BOOL *stop){
        if (obj == [NSNull null]) {
            [mutableArray addObject:@""];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [mutableArray addObject:[self returnArray:array]];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [mutableArray addObject:[self returnDictionary:obj]];
        } else {
            [mutableArray addObject:obj];
        }
    }];
    return mutableArray;
}

+ (NSDictionary *)returnDictionary:(NSDictionary *)params {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if (obj == [NSNull null]) {
            [dictionary setObject:@"" forKey:key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [dictionary setObject:[self returnArray:obj] forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [dictionary setObject:[self returnDictionary:obj] forKey:key];
        } else {
            [dictionary setObject:obj forKey:key];
        }
    }];
    return dictionary;
}

+ (NSString *)dateStringWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setTimeZone:timeZone];
    //    [timeFormat setDateFormat:@"M月d日 HH:mm"];
    [timeFormat setDateFormat:@"YYYY年M月d日"];
    return [timeFormat stringFromDate:date];
}

+ (NSString *)dateStartTimeWithTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setTimeZone:timeZone];
    [timeFormat setDateFormat:@"YYYY年M月d日 HH:mm"];
    return [timeFormat stringFromDate:date];
}

+ (NSString *)dateNoYearStringWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setTimeZone:timeZone];
    //    [timeFormat setDateFormat:@"M月d日 HH:mm"];
    [timeFormat setDateFormat:@"M月d日"];
    return [timeFormat stringFromDate:date];
}

+ (NSString *)timeStringWithFullDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 23:59:00"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)timeStringWithFormat:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M月d日"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)getDateWithTimeString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}

+ (NSTimeInterval)timeIntervalWithTimeString:(NSString *)timeString {
    
    NSTimeInterval interval;
    NSDate *date = [YCTools getDateWithTimeString:timeString];
    interval = [date timeIntervalSince1970];
    return interval;
}


+ (NSTimeInterval)timeInterValWithDateInterVal:(NSTimeInterval)dateInt withHourString:(NSString *)hourString {
    NSTimeInterval interval;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setTimeZone:timeZone];
    [timeFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [timeFormat stringFromDate:date];
    interval = [YCTools timeIntervalWithTimeString:[NSString stringWithFormat:@"%@ %@:00",dateString,hourString]];
    return interval;
}

+ (NSString *)timeStringTotimeStamp:(NSTimeInterval)toTime  from:(NSTimeInterval)fromTime
{
    //获取当前时间时间串
    //与获得时间串进行对比
    //根据时间差显示不同内容
    //返回内容
    NSTimeInterval gapTime = toTime - fromTime;
    NSString *timeStamp = nil;
    if (gapTime > 0 && gapTime < 60) {
        //一分钟内显示刚刚
        timeStamp = [NSString stringWithFormat:@"1分钟"];
    }else if(60<=gapTime && gapTime<60*60){
        //一分钟以上且一个小时之内的，显示“多少分钟前”，例如“5分钟前”
        timeStamp = [NSString stringWithFormat:@"%.0f分钟",gapTime/60];
    }else if (60*60<=gapTime && gapTime<60*60*24){
        //一小时以上且一天之内的，显示“多少小时”，例如“5小时”
        timeStamp = [NSString stringWithFormat:@"%.0f小时",gapTime/(60*60)];
    }else if (gapTime < 0){
        timeStamp = @"用车时间已过";
    }else{
        //大于一天 显示 几天
        timeStamp = [NSString stringWithFormat:@"%.0f天",gapTime/(60*60*24)];
    }
    return [timeStamp copy];
}

/**
 *  orderListModel
 *
 *  时间转换
 */
+ (NSString *)formatStartTime:(double)timeString {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeString];
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    //    dateformatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    NSString * dateString = [dateformatter stringFromDate:date];
    return dateString;
}

+ (NSString *)formatEndTime:(double)timeString {
    NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:timeString];
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    //结束时间
    [dateformatter setDateFormat:@"HH:mm"];
    NSString * dateString = [dateformatter stringFromDate:startDate];
    
    return dateString;
}
@end
