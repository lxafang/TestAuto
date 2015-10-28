//
//  QJTools.m
//  QiJi_Driver
//
//  Created by liuxu'an on 15/7/24.
//  Copyright (c) 2015年 liuxu'an. All rights reserved.
//

#import "QJTools.h"
#import <sys/sysctl.h>
#import <mach/mach_time.h>
#import <CommonCrypto/CommonDigest.h>

#define OneDaySecond 24*60*60

@implementation QJTools

#pragma mark - 文件

+ (NSString *)getDocumentsDirectory {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*)getCacheDirectory {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

+ (NSString*)getPathByFileName:(NSString *)_fileName
{
    NSString* fileDirectory = [[self getCacheDirectory] stringByAppendingPathComponent:_fileName];
    return fileDirectory;
}

+ (BOOL)isExistsFileWithPath:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

+ (BOOL)deleteFilePath:(NSString*)path {
    BOOL success = YES;
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!success) {
            DLog(@"remove file error %@",error.localizedDescription);
        }
    }
    return success;
}

+ (BOOL)createFolderToPath:(NSString *)aPath
{
    
    if (![self isExistsFileWithPath:aPath]) {
        
        return [[NSFileManager defaultManager] createDirectoryAtPath:aPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (BOOL)createFileToPath:(NSString *)aPath
{
    if (![self isExistsFileWithPath:aPath]) {
        
        return [[NSFileManager defaultManager] createFileAtPath:aPath contents:nil attributes:nil];
    }
    return YES;
    
}

+ (BOOL)appendString:(NSString *)str toPath:(NSString *)aPath
{
    if ([self isExistsFileWithPath:aPath]) {
        //追加崩溃信息
        NSFileHandle * outFile;
        NSData * buffer;
        outFile = [NSFileHandle fileHandleForWritingAtPath:aPath];
        if (outFile == nil) {
            DLog(@"---open file failed");
        }
        [outFile seekToEndOfFile];
        buffer = [str dataUsingEncoding:NSUTF8StringEncoding];
        [outFile writeData:buffer];
        [outFile closeFile];
        return YES;
    }
    return [str writeToFile:aPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)saveString:(NSString *)str toPath:(NSString *)aPath
{
    return [str writeToFile:aPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *)readDataFromPath:(NSString *)aPath
{
    if (![self isExistsFileWithPath:aPath]) {
        return @"";
    }
    
    return [NSString stringWithContentsOfFile:aPath encoding:NSUTF8StringEncoding error:nil];
}

+ (unsigned long long)fileSizeAtPath:(NSString * )aPath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:aPath]) {
        return [[manager attributesOfItemAtPath:aPath error:nil] fileSize];
    }
    return 0;
}

+ (NSArray *)getContentsOfPath:(NSString *)aPath {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:aPath]) {
        return [manager  directoryContentsAtPath:aPath];
    }
    return [NSArray array];
}

#pragma mark - 时间

/** yyyy-MM-dd HH:mm:ss -> yyyy-MM-dd */
+ (NSString *)dateStringNoHMSWithTimeString:(NSString *)timeString {
    NSDate *date = [QJTools getDateWithTimeString:timeString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/** yyyy-MM-dd HH:mm:ss -> yy-MM-dd */
+ (NSString *)dateStringNoYHMSWithTimeString:(NSString *)timeString {
    NSDate *date = [QJTools getDateWithTimeString:timeString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/** yyyy-MM-dd HH:mm:ss -> yyyy-MM-dd HH:mm */
+ (NSString *)dateStringNoSecondWithTimeString:(NSString *)timeString {
    NSDate *date = [QJTools getDateWithTimeString:timeString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
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
    [timeFormat setDateFormat:@"M月d日 HH:mm"];
    //    [timeFormat setDateFormat:@"M月d日"];
    return [timeFormat stringFromDate:date];
}
+ (NSString *)getDateStringFromRow:(NSInteger)row
{
    //    NSLog(@"%f",[[NSDate date] timeIntervalSince1970]);
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:row * OneDaySecond];
    //    NSLog(@"%f",[currentDate timeIntervalSince1970]);
    NSString *dateString = [QJTools timeStringWithFormat:currentDate];
    return dateString;
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
    NSDate *date = [QJTools getDateWithTimeString:timeString];
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
    interval = [QJTools timeIntervalWithTimeString:[NSString stringWithFormat:@"%@ %@:00",dateString,hourString]];
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


#pragma mark - MD5

+ (NSString *)md5:(NSString *)str {
    if (!str) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - 校验

/** 手机号码转换 */
+ (NSString *)convertCelllphone:(NSString *)cellphone {
    NSMutableString *mutableStr = [NSMutableString stringWithString:cellphone];
    if (cellphone.length == 11) {
        [mutableStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else {
        //TODO:固话
    }
    return mutableStr;
}

+ (BOOL)checkCellphone:(NSString *)cellphone {
    //NSString *Regex = @"(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9])\\d{8}";
//    NSString *Regex = @"(1[0-9])\\d{9}";
    NSString *Regex = @"^(1(([35][0-9])|(47)|[8][01236789]))\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:cellphone];
}

+ (BOOL)checkPassWord:(NSString *)password {
    NSString * regex = @"(^[A-Za-z0-9]{6,14}$)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

+ (BOOL)isBlankObject:(id)object {
    if (object == nil) {
        return YES;
    }
    if (object == NULL) {
        return YES;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    if ([object isKindOfClass:[NSString class]]) {
        if ([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
            return YES;
        } else {
            const char *str = [object UTF8String];
            if (strlen(str) == 0) {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)isBlack:(id)responseObject {
    /*
    [[YCUser currentUser] setAccessToken:nil];
    [YCUser currentUser].catcheDic = nil;
    DefaultSetValueForKey(nil, kCredentialsToken);
    if (responseObject[@"ret_msg"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                           message:responseObject[@"ret_msg"]
                                                          delegate:self
                                                 cancelButtonTitle:@"我知道了"
                                                 otherButtonTitles:nil];
        [alertView show];
        DefaultSetValueForKey(@"1", @"isblack");
        [[alertView rac_buttonClickedSignal] subscribeNext:^(id buttonIndex) {
            if ([buttonIndex integerValue] == 0) {
                YCAppDelegate *app = (YCAppDelegate *)[UIApplication sharedApplication].delegate;
                UIWindow *window = app.window;
                [UIView animateWithDuration:0.5f animations:^{
                    window.alpha = 0;
                    window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
                } completion:^(BOOL finished) {
                    DefaultSetValueForKey(@"0", @"isblack");
                    exit(0);
                }];
            }
        }];
    }*/
}

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark - NSString

/*
+ (NSAttributedString *)createAttributerStringWithString:(NSString *)string;
{
    NSMutableAttributedString *attributerString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributerString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont systemFontOfSize:15.f],
                                     NSFontAttributeName,
                                     kQJRed,
                                     NSForegroundColorAttributeName,
                                     nil] range:NSMakeRange(0, 1)];
    return attributerString;
}*/

@end
