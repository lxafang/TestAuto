//
//  WXController.h
//  DoBe
//
//  Created by liuxu'an on 15/9/8.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResp;

@interface WXController : UIViewController

- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp;

@end
