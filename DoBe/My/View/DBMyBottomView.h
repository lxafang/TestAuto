//
//  DBMyBottomView.h
//  DoBe
//
//  Created by liuxuan on 15/6/10.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BottomEventTypeBlock)(NSInteger type);

@interface DBMyBottomView : UIView

@property (nonatomic, copy) BottomEventTypeBlock bottomEventTypeBlock;

@end
