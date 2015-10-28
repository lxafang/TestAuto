//
//  DBCommentBottomView.h
//  DoBe
//
//  Created by liuxuan on 15/6/16.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CameraEventBlock)(void);
typedef void(^SendEventBlock)(NSString *str, BOOL isSend);

@interface DBCommentBottomView : UIView

@property (nonatomic, copy) CameraEventBlock cameraEventBlock;
@property (nonatomic, copy) SendEventBlock   sendEventBlock;

- (void)setFieldText:(NSString *)text;

- (void)setFieldResignFirstResponder;

@end
