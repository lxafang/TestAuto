//
//  DefaultDefine.h
//  iWeidao
//
//  Created by yongche on 14-9-10.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#ifndef iWeidao_DefaultDefine_h
#define iWeidao_DefaultDefine_h


//界面宽高
#define BatteryHeight 20.0
#define NavBarHeight  44.0
#define TabBarHeight  49.0

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define is_iphone4          (([UIScreen mainScreen].bounds.size.height)==480)
#define is_iphone5          (([UIScreen mainScreen].bounds.size.height)==568)
#define is_iphone6          (([UIScreen mainScreen].bounds.size.height)==667)
#define is_iphone6Plus      (([UIScreen mainScreen].bounds.size.height)==736)


#define SAFE_RELEASE(x) [x release];x=nil  //release

#define APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])  //应用程序版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]   //ios系统版本号

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0]) //语言

//颜色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//NSLog
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#ifdef DEBUG
#define D_NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define D_NSLog(format, ...)
#endif

#define _po(o) DLOG(@"%@", (o))
#define _pn(o) DLOG(@"%d", (o))
#define _pf(o) DLOG(@"%f", (o))
#define _ps(o) DLOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) DLOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.x, (o).size.width, (o).size.height)
#define DOBJ(obj)  DLOG(@"%s: %@", #obj, [(obj) description])
#define MARK    NSLog(@"\nMARK: %s, %d", __PRETTY_FUNCTION__, __LINE__)

//alert
#define alertContent(content) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" \
message:content \
delegate:nil   \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil];  \
[alert show];  \
[alert release];

// app信息
#define kAppBundleIdentifier [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"]

//当前设备类型判断
#define DeviceIsIphone4 CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
#define DeviceIsIphone5 CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define DeviceIsIphone6 CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define DeviceIsIphone6plus CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
#define InputCGRectFrom(x,y,width,height)  CGRectMake(x, y, width, height);
#define is_Width320         (([UIScreen mainScreen].bounds.size.width)==320)    //iPhone4,4s,5,5s


#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif


//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define USER_DEFAULT [NSUserDefaults standardUserDefaults] //user Default

//image
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//例如 imageView.image =  LOADIMAGE(@"文件名",@"png");

// degrees/radian functions
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]

//
#define ITTDEBUG
#define ITTLOGLEVEL_INFO     10
#define ITTLOGLEVEL_WARNING  3
#define ITTLOGLEVEL_ERROR    1

#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

//common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }


// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)  ((void)0)
#endif

#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
ITTDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

// 断言
#define ITTAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)


/**
 *
 * 常用的方法
 *
 **/
#pragma mark - Common Method
#define kTabBarHeight       64
#define kToolBarHeight      44
#define kStatusbarHeight    20

#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height
#define kNavHeight          [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0 ? 64.0f : 44.0f

//系统版本
#define IOS8                [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define IOS7                [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define kSystemVersion      [[[UIDevice currentDevice] systemVersion] floatValue]

//文件路径
#define kPATH_OF_APP_HOME       NSHomeDirectory()
#define kPATH_OF_TEMP           NSTemporaryDirectory()
#define kPATH_OF_DOCUMENT       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPATH_OF_CACHES         [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kAddressDirectory       [kPATH_OF_CACHES stringByAppendingString:@"/Address/"]

//基本类值的转换和取值
#define SetValueForKey(dic,value,key)       [dic setValue:value forKey:key];
#define DoubleToString(x)                   [NSString stringWithFormat:@"%f",x]
#define IntToString(x)                      @(x).stringValue
#define NumberToString(x)                   [NSString stringWithFormat:@"%@",x]
#define OrderResultKey(x)                   [NSString stringWithFormat:@"%@OrderResult",x]
#define DefaultValueForKey(key)             [[NSUserDefaults standardUserDefaults] valueForKey:key]
#define DefaultSetValueForKey(value,key)    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];


#define DefaultObjdectForKey(key)          [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define DefaultSetObjectForKey(object,key)    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];


//十六进制的颜色
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//navBar颜色
//RGB(131, 194, 48)
#define kNavBarColor [UIColor \
colorWithRed:131.0f/255.0 \
green:194.0f/255.0 \
blue:48.0/255.0 \
alpha:1.0]

//浅灰色
#define LightGray [UIColor \
colorWithRed:240.0/255.0 \
green:240.0/255.0 \
blue:240.0/255.0 \
alpha:1.0]

//黑色文字
#define LightTextBlack [UIColor \
colorWithRed:34.0/255.0 \
green:34.0/255.0 \
blue:34.0/255.0 \
alpha:1.0]


//浅灰色文字
#define LightTextGray [UIColor \
colorWithRed:153.0/255.0 \
green:153.0/255.0 \
blue:153.0/255.0 \
alpha:1.0]

//导航条的红色
#define NavRed [UIColor \
colorWithRed:238.0/255.0 \
green:65.0/255.0 \
blue:54.0/255.0 \
alpha:1.0]

#define YDRed [UIColor \
colorWithRed:236.0/255.0 \
green:73.0/255.0 \
blue:73.0/255.0 \
alpha:1.0]


//自定义颜色
#define FastColor(x,y,z) [UIColor \
colorWithRed:x/255.0 \
green:y/255.0 \
blue:z/255.0 \
alpha:1.0]


#define WINDOW_HEIGHT ([[UIScreen mainScreen] bounds].size.height ? [[UIScreen mainScreen] bounds].size.height : 480)

/**
 *  国际化相关
 */
#define kCurrentLanguageBundle [[YCLanguageTools shareInstance] languageBundle]
#define kCurrentLanguageForKey(key) [[YCLanguageTools shareInstance] locatizedStringForkey:key]
#define kCurrentSystemLanguage   [[NSLocale preferredLanguages] objectAtIndex:0]

#define kZh_Hans @"zh-Hans"     // 中文
#define kEn @"en"               // 英文

/**
 *  NSUserDefault 操作相关的宏定义
 */

#define setValueAndKeyToUserDefault(value,key)     [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];\
                                       [[NSUserDefaults standardUserDefaults] synchronize];

#define getValueForKeyFromUserDefault(key)           [[NSUserDefaults standardUserDefaults] objectForKey:key];

#define kCurrentBuildConfig @"currentBuildConfig"       //当前的build环境{debug，release、debug_online}
#define kOpenEmailDubug @"isOpenEmailDubug"  //是否关闭Email崩溃调试



// 颜色自定义
#define YCColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


//
#define kStatusHeight 20
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define padding 20
#define itemPerLine 4
#define kItemW (kScreenW-padding*(itemPerLine+1))/itemPerLine
#define kItemH 25

typedef enum{
    topViewClick = 0,
    FromTopToTop = 1,
    FromTopToTopLast = 2,
    FromTopToBottomHead = 3,
    FromBottomToTopLast = 4
} animateType;

#pragma mark - DoBe相关

//系统字体颜色
//橙色字体 RGB(241, 151, 38)
#define kOrangeColor   RGB(241, 151, 38)
#define kLightTextGray RGB(136, 136, 136)
#define kBorderColor   RGB(200, 199, 204)
#define kButtonBgColor RGB(228, 91, 34)


//字体定义


#define kNormalFont     [UIFont systemFontOfSize:15.0f]

#define kSmallSizeFont  [UIFont systemFontOfSize:13.0f]
#define kMiddleSizeFont [UIFont systemFontOfSize:15.0f]
#define kLargeSizeFont  [UIFont systemFontOfSize:17.0f]

#endif
