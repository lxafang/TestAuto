//
//  DBHomeController.m
//  DoBe
//
//  Created by liuxuan on 15/6/2.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBHomeController.h"
#import "DBHeadlineView.h"
#import "DBBottomView.h"
#import "DBCommendView.h"
#import "DBArticleDetailVC.h"

@interface DBHomeController () {
    UIScrollView *_mainScroller;
}



@end

@implementation DBHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSubViews {
    _mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30 + 64.0f, kScreenW, kScreenH-200)];
    _mainScroller.bounces = NO;
    _mainScroller.pagingEnabled = YES;
    _mainScroller.showsHorizontalScrollIndicator = NO;
    _mainScroller.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:_mainScroller atIndex:0];
    _mainScroller.contentSize = CGSizeMake(kScreenW*10, kScreenH - 200);
    
    /** 文章列表 */
    DBCommendView *commendView = [[DBCommendView alloc] initWithFrame:CGRectMake(0.0f, 0.f, kScreenW, kScreenH-200)];
    [_mainScroller addSubview:commendView];
    commendView.didSelectRowBlock = ^(NSInteger row){
        NSLog(@"点击第%ld行",(long)row);
        //选择数据
        DBArticleDetailVC *detailVC = [[DBArticleDetailVC alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    };
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
