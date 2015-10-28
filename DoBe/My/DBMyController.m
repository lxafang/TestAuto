//
//  DBMyController.m
//  DoBe
//
//  Created by liuxuan on 15/6/3.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBMyController.h"
#import "DBAccountVC.h"
#import "DBDownloadManagerVC.h"
#import "DBFeedbackVC.h"
#import "DBSettingVC.h"
#import "DBMyHeadView.h"
#import "DBMyBottomView.h"
#import "AppDelegate.h"
#import "QJHTTPClient.h"
#import "DBUserModel.h"
#import <MJExtension.h>
#import "DBCollectionVC.h"
#import "DBSubscribeVC.h"

@interface DBMyController ()<UITableViewDataSource,UITableViewDelegate> {
    DBUserModel *_userModel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DBMyController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userModel = [DBUserModel getUserInfo];
    [self loadSubViews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view

- (void)loadSubViews {
    if (is_iphone5) {
        _tableView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 449.0f);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
    CGFloat height = _tableView.height;
    UIView *bottomBgView = [[UIView alloc] init];
    bottomBgView.backgroundColor = RGB(241, 241, 241);
    bottomBgView.frame = CGRectMake(0.0f, height, kScreenWidth, kScreenHeight - height);
    [self.view addSubview:bottomBgView];
    
    DBMyBottomView *bottomView =[[NSBundle mainBundle] loadNibNamed:@"DBMyBottomView" owner:self options:nil][0];
    bottomView.frame = CGRectMake(0.0f, bottomBgView.height - 100.0f, kScreenWidth, 100.0f);
    [bottomBgView addSubview:bottomView];
    
    bottomView.bottomEventTypeBlock = ^(NSInteger tag){
        UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        if (tag == 1001) {
            NSLog(@"离线下载");
            DBDownloadManagerVC *downloadVC = [myStoryboard instantiateViewControllerWithIdentifier:@"DBDownloadManagerVC"];
            [self.navigationController pushViewController:downloadVC animated:YES];
        }else if (tag == 1002) {
            NSLog(@"夜间模式");
        }else if (tag == 1003) {
            NSLog(@"意见反馈");
            DBFeedbackVC *feedbackVC = [myStoryboard instantiateViewControllerWithIdentifier:@"DBFeedbackVC"];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }else if(tag == 1004) {
            NSLog(@"设置");
            DBSettingVC *settingVC = [myStoryboard instantiateViewControllerWithIdentifier:@"DBSettingVC"];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    };
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"MyCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSInteger row = indexPath.row;
    [cell.textLabel setFont:kNormalFont];
    switch (row) {
        case 0:{  //收藏
            [cell.imageView setImage:[UIImage imageNamed:@"my_collect"]];
            [cell.textLabel setText:@"我的收藏"];
        }   break;
        case 1: {
            [cell.imageView setImage:[UIImage imageNamed:@"my_message"]];
            [cell.textLabel setText:@"我的消息"];
        }   break;
        case 2:{
            [cell.imageView setImage:[UIImage imageNamed:@"my_book"]];
            [cell.textLabel setText:@"我的订阅"];
        }   break;
        case 3:{
            [cell.imageView setImage:[UIImage imageNamed:@"my_recent"]];
            [cell.textLabel setText:@"最近阅读"];
        }   break;
        default:
            break;
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (is_iphone5) {
        return 50.0f;
    }
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    switch (row) {
        case 0: { //我的收藏
            DBCollectionVC *collectVC = (DBCollectionVC *)[self instantiateViewControllerWithIdentifier:@"DBCollectionVC" withStoryboardName:@"My"];
            [self.navigationController pushViewController:collectVC animated:YES];
                    }
            break;
        case 1: { //我的消息
            
        }
            break;

        case 2: {
            DBSubscribeVC *subVC = (DBSubscribeVC *)[self instantiateViewControllerWithIdentifier:@"DBSubscribeVC" withStoryboardName:@"My"];
            [self.navigationController pushViewController:subVC animated:YES];
        }
            break;

        case 3: {
            
        }
            break;

            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 230.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /** 用户信息 */
    DBMyHeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"DBMyHeadView" owner:self options:nil][0];
    
    headView.editUserInfoBlock = ^{
        UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        DBAccountVC *accountVC = [myStoryboard instantiateViewControllerWithIdentifier:@"DBAccountVC"];
        [self.navigationController pushViewController:accountVC animated:YES];
    };
    return headView;
}

//处理分隔线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15.0f, 0, 15.0f)];
        }
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - event

- (IBAction)backTouchUpInsideClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSubViewsEvent {
    
}

#pragma mark - request

/** 获取个人信息 @lxa */
- (void)requestUserProfile {
    
    [self showProgressHUD];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kUserProfile parameters:@{keyUserId:[DBUserModel getUserId]}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DLog(@"个人信息:%@",dic);
        _userModel = [DBUserModel initUserModelWithDictionary:dic[@"result"]];
        [self hideProgressHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error.description);
        [self hideProgressHUD];
    }];
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
