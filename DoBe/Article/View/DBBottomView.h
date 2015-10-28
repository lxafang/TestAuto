//
//  DBBottomView.h
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BottomEventBlock)(NSInteger tag);

@interface DBBottomView : UIView

@property (nonatomic, copy)   BottomEventBlock bottomEventBlock;
@property (nonatomic, assign) NSInteger        commentCount;  //角标 badge

- (void)resetCommentCount:(NSInteger)commentCount;

@end
