//
//  DBNormalCell.h
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBArticleModel.h"

@interface DBNormalCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *wxNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLab;

@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;

- (void)setCellData:(DBArticleModel *)model;

@end
