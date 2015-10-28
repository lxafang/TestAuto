//
//  DBType.h
//  DoBe
//
//  Created by liuxuan on 15/6/2.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#ifndef DoBe_DBType_h
#define DoBe_DBType_h


#import "DBUser.h"

/*
 segmentbutton 类型
 */
typedef NS_ENUM (NSInteger, segmentButtonType){
    plain = 0, //扁平类型,用于切换城市
    rounded = 1 //圆角类型,用于切换接送机
}  ;



typedef NS_ENUM(NSUInteger, DBStandType) {
    DBStandTypeGood = 1,  /**< 好评 */
    DBStandTypeBad  = 2,  /**< 差评 */
};

typedef NS_ENUM(NSUInteger, DBFontSize) {
    DBFontSizeMinor  = 220,  /**< 小  220 */
    DBFontSizeMedium = 260,  /**< 中等 260 */
    DBFontSizeBig    = 300,  /**< 大 300 */
    DBFontSizeHuge   = 350,  /**< 超大 350 */
};

#endif
