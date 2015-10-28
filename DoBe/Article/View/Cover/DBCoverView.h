//
//  DBCoverView.h
//  DoBe
//
//  Created by liuxuan on 15/6/14.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CoverFinishEventBlock)();
typedef void(^CoverBottomBlock)(NSInteger tag);
typedef void(^CoverFontSizeBlock)(NSInteger index);
@interface DBCoverView : UIView

@property (nonatomic, copy) CoverFinishEventBlock coverFinishBlock;
@property (nonatomic, copy) CoverBottomBlock coverBottomBlock;
@property (nonatomic, copy) CoverFontSizeBlock coverFontSizeBlock;

@end
