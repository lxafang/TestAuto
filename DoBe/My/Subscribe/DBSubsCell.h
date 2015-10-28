//
//  DBSubsCell.h
//  DoBe
//
//  Created by liuxu'an on 15/10/11.
//  Copyright © 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubscribeEventBlock)(BOOL isDone);

@class DBWXModel;

@interface DBSubsCell : UITableViewCell {
    
}

@property (nonatomic, assign) BOOL isSubed;
@property (nonatomic, copy) SubscribeEventBlock subscribeEventBlock;  /**< 订阅 或 取消 */


- (void)setCellInfoWithModel:(DBWXModel *)info;

@end
