//
//  DBCoverCell.h
//  DoBe
//
//  Created by liuxuan on 15/6/15.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CoverCellEventBlock)(NSInteger tag);

@interface DBCoverCell : UITableViewCell

@property (nonatomic, copy)CoverCellEventBlock coverCellEventBlock;

@end
