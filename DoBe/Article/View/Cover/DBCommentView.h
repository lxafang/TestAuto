//
//  DBCommentView.h
//  DoBe
//
//  Created by liuxuan on 15/6/16.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendCommentEventBlock)(NSString *commentStr, BOOL isSend);

@interface DBCommentView : UIView

@property (nonatomic, copy) SendCommentEventBlock sendCommentBlock;

- (void)setFirstResponder;
@end
