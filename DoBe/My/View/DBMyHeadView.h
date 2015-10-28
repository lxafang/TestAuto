//
//  DBMyHeadView.h
//  DoBe
//
//  Created by liuxuan on 15/6/9.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditUserInfoBlock)();

@interface DBMyHeadView : UIView

@property (nonatomic, copy)EditUserInfoBlock editUserInfoBlock;

@end
