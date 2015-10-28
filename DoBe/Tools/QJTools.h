//
//  QJTools.h
//  QiJi_Driver
//
//  Created by liuxu'an on 15/7/24.
//  Copyright (c) 2015年 liuxu'an. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJTools : NSObject

#pragma mark - 文件

/** 获取Document文件路径 */
+ (NSString*)getDocumentsDirectory;

/** 获取Cache文件路径 */
+ (NSString*)getCacheDirectory;

/** 获取fileName文件所在的路径 */
+ (NSString*)getPathByFileName:(NSString *)_fileName;

/** 判断某路径的文件是否存在 */
+ (BOOL)isExistsFileWithPath:(NSString*)path;

/** 删除某路径下的文件 */
+ (BOOL)deleteFilePath:(NSString*)path;

/** 追加数据data 到 path目录下 */
+ (BOOL)appendString:(NSString *)str toPath:(NSString *)aPath;

/** 保存数据data 到 path目录下 */
+ (BOOL)saveString:(NSString *)str toPath:(NSString *)aPath;

/** 读取某路径下的文件 */
+ (NSString *)readDataFromPath:(NSString *)aPath;

/** 在path路径下创建文件夹 */
+ (BOOL)createFolderToPath:(NSString *)aPath;

/** aPath路径下文件的大小 */
+ (unsigned long long)fileSizeAtPath:(NSString * )aPath;

/** 创建某个文件 */
+(BOOL)createFileToPath:(NSString *)aPath;

/** 获取path路径下的所有文件名 */
+ (NSArray *)getContentsOfPath:(NSString *)aPath;

#pragma mark - 时间

/** yyyy-MM-dd HH:mm:ss -> yyyy-MM-dd */
+ (NSString *)dateStringNoHMSWithTimeString:(NSString *)timeString;

/** yyyy-MM-dd HH:mm:ss -> yy-MM-dd */
+ (NSString *)dateStringNoYHMSWithTimeString:(NSString *)timeString;

/** yyyy-MM-dd HH:mm:ss -> yyyy-MM-dd HH:mm */
+ (NSString *)dateStringNoSecondWithTimeString:(NSString *)timeString;

+ (NSString *)dateStringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)dateStartTimeWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)dateNoYearStringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)getDateStringFromRow:(NSInteger)row;

+ (NSString *)timeStringWithFullDate:(NSDate *)date;

+ (NSString *)timeStringWithFormat:(NSDate *)date;

/** yyyy-MM-dd HH:mm:ss -> date */
+ (NSDate *)getDateWithTimeString:(NSString *)timeString;

+ (NSString *)timeStringTotimeStamp:(NSTimeInterval)toTime  from:(NSTimeInterval)fromTime;

+ (NSTimeInterval)timeIntervalWithTimeString:(NSString *)timeString;

+ (NSTimeInterval)timeInterValWithDateInterVal:(NSTimeInterval)dateInt withHourString:(NSString *)hourString;

#pragma mark - 加密

+ (NSString *)md5:(NSString *)str;

#pragma mark - 校验

/** 手机号码转换 */
+ (NSString *)convertCelllphone:(NSString *)cellphone;

/** 判断手机号是否合法 */
+ (BOOL)checkCellphone:(NSString *)cellphone;

/** 判断密码是否合法 */
+ (BOOL)checkPassWord:(NSString *)password;

/** 判断object为空 */
+ (BOOL)isBlankObject:(id)object;

/** 黑设备 */
//+ (void)isBlack:(id)responseObject;

#pragma mark - 图片

/** 自动缩放到指定大小 */
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

/** 保持原来的长宽比，生成一个缩略图 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

#pragma mark - NSString

/** kQJRed 带*标注为红色 */
+ (NSAttributedString *)createAttributerStringWithString:(NSString *)string;


@end

