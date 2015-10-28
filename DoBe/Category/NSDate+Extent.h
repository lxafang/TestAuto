//
//  NSDate+Extent.h
//  iWeidao
//
//  Created by 赵学智 on 14/12/18.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extent)


+ (NSString *)hourStringFromDate:(NSDate *)date;

+ (NSString *)minuteStringFromDate:(NSDate *)date;

+ (NSString *)weekDayFromDate:(NSDate *)date;

@end
