//
//  NSDate+Extent.m
//  iWeidao
//
//  Created by 赵学智 on 14/12/18.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import "NSDate+Extent.h"

@implementation NSDate(Extent)

+ (NSString *)hourStringFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSInteger hour;
    
    comps = [calendar components:unitFlags fromDate:date];
    hour = [comps hour];
    
    return [NSString stringWithFormat:@"%ld",(long)hour];
}

+ (NSString *)minuteStringFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSInteger minute;
    
    comps = [calendar components:unitFlags fromDate:date];
    minute = [comps minute];
    
    return [NSString stringWithFormat:@"%ld",(long)minute];
}

+ (NSString *)weekDayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSInteger week;
    NSString *weekStr=nil;
    
    comps = [calendar components:unitFlags fromDate:date];
    week = [comps weekday];
    
    if(week==1)
    {
        weekStr=@"周日";
    }else if(week==2){
        weekStr=@"周一";
        
    }else if(week==3){
        weekStr=@"周二";
        
    }else if(week==4){
        weekStr=@"周三";
        
    }else if(week==5){
        weekStr=@"周四";
        
    }else if(week==6){
        weekStr=@"周五";
        
    }else if(week==7){
        weekStr=@"周六";
    }
    
    return weekStr;
}


@end
