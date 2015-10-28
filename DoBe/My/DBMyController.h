//
//  DBMyController.h
//  DoBe
//
//  Created by liuxuan on 15/6/3.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBBaseController.h"


typedef void(^SendAuthRequestBlock)(UIViewController *viewController);

@interface DBMyController : DBBaseController

@property (nonatomic, copy) SendAuthRequestBlock sendAuthRequestBlock;

@end
