//
//  DBBaseController.m
//  DoBe
//
//  Created by liuxuan on 15/6/2.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBBaseController.h"

@interface DBBaseController ()

@end

@implementation DBBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)showBackButton
{
    UIImage *image = [UIImage imageNamed:@"back"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,44, 44)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)backBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
