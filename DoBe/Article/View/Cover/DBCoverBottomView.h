//
//  DBCoverBottomView.h
//  DoBe
//
//  Created by liuxuan on 15/6/14.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CoverBottomEventBlock)(NSInteger tag);
@interface DBCoverBottomView : UIView

@property (nonatomic, copy)CoverBottomEventBlock coverBottomEventBlock;

@end
