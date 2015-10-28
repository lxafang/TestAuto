//
//  DBAccountVC.m
//  DoBe
//
//  Created by liuxuan on 15/6/3.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBAccountVC.h"
#import "QJHTTPClient.h"
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DBAccountVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;

@property (nonatomic, strong) DBUserModel *userInfo;
@end

@implementation DBAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号管理";
    [self showBackButton];
    
    _userInfo = [DBUserModel getUserInfo];
    if (is_iphone5) {
        _tableView.frame = CGRectMake(0.f, 0.f, kScreenWidth, 440.0f);
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [self setExtraCellLineHidden:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event

- (IBAction)loginOutTouchUpInside:(id)sender {
    
    NSLog(@"退出登录");
    [DBLoginModel sharedInstance].access_token = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToLoginPage object:self];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 3;
    if (section == 1) {
        count = 5;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UserInfoTopCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        switch (row) {
            case 0:{
                [cell.textLabel setText:@"头像"];
                UIImage *image = [UIImage imageNamed:_userInfo.avatar];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = image;
                CGFloat height = 60.0f;
                if (is_iphone5) {
                    height = 50.0f;
                }
                imageView.frame = CGRectMake(80.0f, (height - image.size.height)/2, image.size.width, image.size.height);
                [cell.contentView addSubview:imageView];
            }
                break;
            case 1:{
                [cell.textLabel setText:@"姓名"];
                [self createCellTextDetailLabel:_userInfo.user_name withSuperView:cell.contentView];
            }
                break;
            case 2:{
                [cell.textLabel setText:@"签名"];
                [self createCellTextDetailLabel:_userInfo.signature withSuperView:cell.contentView];
            }
                break;

            default:
                break;
        }
    }else {
        [cell.detailTextLabel setText:@"点击修改"];
        [cell.detailTextLabel setTextColor:RGB(241, 151, 38)];
        switch (row) {
            case 0:{
                [cell.textLabel setText:@"电话"];
                [self creatCellTextField:_userInfo.cellphone withSuperView:cell.contentView tag:row];
            }
                break;
            case 1:{
                [cell.textLabel setText:@"邮箱"];
                [self creatCellTextField:_userInfo.email withSuperView:cell.contentView tag:row];
            }
                break;
            case 2:{
                [cell.textLabel setText:@"城市"];
                [self creatCellTextField:_userInfo.city withSuperView:cell.contentView tag:row];

            }
                break;
            case 3:{
                [cell.textLabel setText:@"地址"];
                [self creatCellTextField:_userInfo.address withSuperView:cell.contentView tag:row];
            }
                break;
            case 4:{
                [cell.textLabel setText:@"标签"];
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40.0f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (is_iphone5) {
        return 50.0f;
    }
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSInteger tag = indexPath.row + 1000;
        UIView *view = [self.view viewWithTag:tag];
        UITextField *textField = (UITextField *)view;
        [textField becomeFirstResponder];
    }
}

- (UIView *)createHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0.f, 0.f, kScreenWidth, 40.0f);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15.0f, 0.f, kScreenWidth - 15.0f, 40.0f);
    label.text = @"其他资料";
    label.textColor = kLightTextGray;
    [headerView addSubview:label];

    UIImageView *seperateLine = [[UIImageView alloc] init];
    seperateLine.frame = CGRectMake(0.f, 0.f, kScreenWidth, 0.5f);
    seperateLine.image = [UIImage imageNamed:@"seperateline"];
    [headerView addSubview:seperateLine];
    
    UIImageView *secondLine = [[UIImageView alloc] init];
    secondLine.frame = CGRectMake(0.0f, 39.5f, kScreenWidth, 0.5f);
    secondLine.image = [UIImage imageNamed:@"seperateline"];
    [headerView addSubview:secondLine];
    
    return headerView;
}

- (void)createCellTextDetailLabel:(NSString *)text withSuperView:(UIView *)superView{
    UILabel *label = [[UILabel alloc] init];
    CGFloat height = 60.0f;
    if (is_iphone5) {
        height = 50.0f;
    }
    label.frame = CGRectMake(80.0f, 0.0f, kScreenWidth - 100.0f, height);
    label.text = text;
    label.textColor = kLightTextGray;
    [superView addSubview:label];
}

- (void)creatCellTextField:(NSString *)text withSuperView:(UIView *)superView tag:(NSInteger)row{
    UITextField *textField = [[UITextField alloc] init];
    CGFloat height = 60.0f;
    if (is_iphone5) {
        height = 50.0f;
    }
    textField.frame = CGRectMake(80.0f, (height - 21.0f)/2, kScreenWidth - 180.0f, 21.0f);
    textField.tag = 1000 + row;
    textField.text = text;
    textField.textColor = kLightTextGray;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    
    [superView addSubview:textField];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [_tableView setContentOffset:CGPointMake(0.f, -64.0f) animated:YES];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSString *text = textField.text;
    switch (textField.tag) {
        case 1000:{
            //电话
            _userInfo.cellphone = text;
        }
            break;
        case 1001:{
            _userInfo.email = text;
        }
            break;
        case 1002:{
            _userInfo.city = text;
        }
            break;
        case 1003:{
            _userInfo.address = text;
        }
            break;
        default:
            break;
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag > 1001) {
        CGFloat top = self.view.height - 216.0f;
        CGFloat offsetY = _tableView.contentOffset.y;
        if (_tableView.bottom > top) {
            [_tableView setContentOffset:CGPointMake(0.f, offsetY + _tableView.bottom - top) animated:YES];
        }
    }
}

#pragma mark - request

/** 修改个人信息 @lxa */
- (void)requestChangeUserProfile {
    [self showProgressHUD];
    NSDictionary *dic = [_userInfo keyValues];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client postClientPath:kUserChangeProfile parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DLog(@"修改个人信息:%@",dic);
        [self requestUserProfile];
        [self hideProgressHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideProgressHUD];
    }];
}


/** 获取个人信息 @lxa */
- (void)requestUserProfile {
    
    [self showProgressHUD];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kUserProfile parameters:@{keyUserId:[DBUserModel getUserId]}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"个人信息:%@",dic);
                      _userInfo = [DBUserModel initUserModelWithDictionary:dic[@"result"]];
                      [_tableView reloadData];
                      
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
