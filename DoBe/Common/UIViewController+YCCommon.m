//
//  UIViewController+YCCommon.m
//  iWeidao
//
//  Created by yongche on 13-11-8.
//  Copyright (c) 2013年 Weidao. All rights reserved.
//

#import "UIViewController+YCCommon.h"
#import "YCProgressHUD.h"
#import "YCSegmentButton.h"
#import "YCSegmentRoundButton.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

//#import "MobClick.h"

@interface UIViewController()


@end

@implementation UIViewController (YCCommon)
@dynamic homeShotImageV, hub;

- (void)showProgressHUD
{
    [self hideProgressHUD];
    [YCProgressHUD showHUDAddedTo:self.view];
}
- (void)hideProgressHUD
{
    [YCProgressHUD hideHUDForView:self.view];
}

- (void)showToastMessage:(NSString *)message withFont:(NSInteger)num
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont boldSystemFontOfSize:num];
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

- (void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

-(void)showPayingToast
{
    self.hub = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self.hub.mode = MBProgressHUDModeIndeterminate;
    self.hub.labelText = @"正在支付";
    [self.navigationController.view addSubview:self.hub];
    [self.hub show:YES];
}

-(void)hidePayToast {
    [self.hub hide:YES];
}

-(void)showPaySuccessToast
{
    self.hub.mode = MBProgressHUDModeCustomView;
    self.hub.labelText = @"支付成功";
    UIImageView * imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_success"]];
    self.hub.customView = imagV;
    [self.hub show:YES];
    [self.hub hide:YES afterDelay:1];

}


-(void)showPayFailureToast
{
    self.hub.mode = MBProgressHUDModeText;
    self.hub.labelText = @"交易未完成";
//    UIImageView * imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_success"]];
//    self.hub.customView = imagV;
    [self.hub hide:YES afterDelay:1];
}

-(void)showPayCancelToast
{
    self.hub.mode = MBProgressHUDModeText;
    self.hub.labelText = @"交易未完成";
    //    UIImageView * imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_success"]];
    //    self.hub.customView = imagV;
    [self.hub hide:YES afterDelay:1];
}

-(void)showPayMsgToast:(NSString *)msg
{   
    self.hub.mode = MBProgressHUDModeText;
    self.hub.labelText = msg;
    //    UIImageView * imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_success"]];
    //    self.hub.customView = imagV;
    [self.hub hide:YES afterDelay:1];
    
}


-(void)showDirctPaySuccessToast
{
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:hub];
    hub.mode = MBProgressHUDModeCustomView;
    hub.labelText = @"支付成功";
    UIImageView * imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_success"]];
    hub.customView = imagV;
    [hub show:YES];
    [hub hide:YES afterDelay:1.5];
}

-(void)showDirctPayFailureToast
{
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:hub];
    hub.mode = MBProgressHUDModeCustomView;
    hub.labelText = @"支付失败";
    UIImageView * imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_success"]];
    hub.customView = imagV;
    [hub show:YES];
    [hub hide:YES afterDelay:1.5];
}


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


#pragma mark - Segment

-(void)addSegmentButtonInNav:(NSArray *)titleArray
{
    YCSegmentButton * cityTypeSelectBtn = [[YCSegmentButton alloc] initWithTitles:titleArray type:rounded];
    cityTypeSelectBtn.frame = CGRectMake(0, 0, 200, 30);
    UIImage * bgImage =[UIImage imageNamed:@"segmentBackground"];
    cityTypeSelectBtn.image = [bgImage stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    cityTypeSelectBtn.selectedColor = [UIColor whiteColor];
    cityTypeSelectBtn.unselectedColor = [UIColor lightGrayColor];
    [cityTypeSelectBtn setSelectedIndex:0];
    __block __weak id tempSelf = self;
    cityTypeSelectBtn.btnPressedBlock = ^(NSInteger index){
        [tempSelf segmentSelectIndex:index];
    };
    self.navigationItem.titleView = cityTypeSelectBtn;
}

-(void)segmentSelectIndex:(NSInteger)index
{
    
}


-(void)addRoundSegmentButton:(NSArray *)titleArray
{
    YCSegmentRoundButton * button = [[YCSegmentRoundButton alloc] initWithItems:titleArray];
    button.frame = CGRectMake(100, 200, 180, 32);
    button.backgroundImage = [UIImage imageNamed:@"segmentBackground"];
    button.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmentRoundSelect"]];
    button.selectedSegmentTextColor = [UIColor whiteColor];
    button.segmentTextColor = UIColor.grayColor;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(roundSegmentSelectIndex:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = button;
}


- (void)showBackButtonWithImage:(NSString *)imagestr
{
    UIImage *image = [UIImage getImageNamed:imagestr];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)showBackButtonWithTitle:(NSString *)title
{
    UIButton *button = [self createButtonWithTitle:title];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
}


- (void)hideBackButton
{
    UIButton *button = [self createButtonWithTitle:@""];
    button.enabled = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
}


- (void)showDownButton{
    UIImage *image = [UIImage imageNamed:@"back"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  image.size.width,
                                                                  image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(downButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;

}

- (void)downButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showRightButtonWithTitle:(NSString *)title
{
    UIButton *button = [self createButtonWithTitle:title];
    [button setTitleColor:RGB(236, 73, 73) forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)hideRightButton
{
    UIButton *button = [self createButtonWithTitle:@""];
    button.enabled = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)showRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color
{
    UIButton *button = [self createButtonWithTitle:title titleColor:color];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)showRightButtonWithImage:(UIImage *)image andHigImage:(UIImage *)higImage
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 44-image.size.width, 0, 0);
    [button setImage:image forState:UIControlStateNormal];
    if (!higImage) {
        [button setImage:image forState:UIControlStateHighlighted];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)showRightBarButtonItemWithTitle:(NSString *)title
{
    UIImage *image = [UIImage imageNamed:@"arrow_down"];
    UIImage *selectedImage = [UIImage imageNamed:@"arrow_up"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(0, 0, 60, 44)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor main_red_C1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button sizeToFit];
    CGRectIntegral(button.frame);
    
    button.frame = CGRectMake(0, 0, button.width + 10, 44);
//
    button.imageEdgeInsets = UIEdgeInsetsMake(2, button.width-image.size.width, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width - 10 , 0, 0);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)showRightBarButtonItemsWithImage:(UIImage *)image andTitle:(NSString *)title
{
    CGFloat height = 44;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, (height - image.size.height)/2, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightFirstBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImage *anotherImage = [UIImage imageNamed:@"arrow_down"];
    UIImage *selectedImage = [UIImage imageNamed:@"arrow_up"];
    UIButton *anotherButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [anotherButton setFrame:CGRectMake(0, 0, 44, 44)];
    [anotherButton setImage:anotherImage forState:UIControlStateNormal];
    [anotherButton setImage:selectedImage forState:UIControlStateSelected];
    [anotherButton setTitle:title forState:UIControlStateNormal];
    [anotherButton setTitleColor:[UIColor main_red_C1] forState:UIControlStateNormal];
    [anotherButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] boundSize:anotherButton.frame.size];
    [anotherButton sizeToFit];
    CGRectIntegral(anotherButton.frame);
    anotherButton.frame = CGRectMake(button.right + 16, 0, button.width + 10, height);
    
    anotherButton.imageEdgeInsets = UIEdgeInsetsMake(2, anotherButton.width-anotherImage.size.width, 0, 0);
    anotherButton.titleEdgeInsets = UIEdgeInsetsMake(0, -anotherImage.size.width - 10, 0, 0);
    [anotherButton addTarget:self action:@selector(rightBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:anotherButton];
    
    view.frame = CGRectMake(0, 0, anotherButton.right - button.left, height);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)showRightButtonWithBackgroundImage:(UIImage *)image andTitle:(NSString *)title
{
    UIButton *button = [self createButtonWithTitle:title];
    CGRect frame = button.frame;
    frame.size.width += 25;
    frame.size.height = 30;
    button.frame = frame;
    image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (UIButton *)getRightButtonFromRightBarButtonItem{
    UIButton *rightButton = (id)self.navigationItem.rightBarButtonItem.customView;
    if ([rightButton isKindOfClass:[UIButton class]]) {
        return rightButton;
    }
    return nil;
}

- (UIButton *)getBackButtonFromRightBarButtonItem{
    UIButton *backButton = (id)self.navigationItem.leftBarButtonItem.customView;
    if ([backButton isKindOfClass:[UIButton class]]) {
        return backButton;
    }
    return nil;
}

-(void)showrightButtonWithStatus:(BOOL)isShow
{
    UIButton *btn = self.navigationController.navigationBar.subviews[2];
    btn.hidden= !isShow;
}


- (void)changeRightBarButtonItemTextColor:(UIColor *)color{
    UIButton *rightButton = [self getRightButtonFromRightBarButtonItem];
    [rightButton setTitleColor:color forState:UIControlStateNormal];
}


- (void)rightBarButtonPressed:(id)sender 
{
    
}

- (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)color
{
    UIButton *btn =[self createButtonWithTitle:title];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}


- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] boundSize:button.frame.size];
    button.frame = CGRectMake(0, 0, size.width, 44);
    return button;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)showNetWorkFailToast {
    [self showToastMessage:kNetWorkErrorTip];
}

- (void)autoLayoutIOS6OrIOS7NavigationBar
{
    //适配ios6和ios7导航透明
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//- (void)umengBeginEventClick:(NSString *)eventId {
//    [MobClick beginLogPageView:eventId];
//}
//
//- (void)umengEndEventClick:(NSString *)eventId {
//    [MobClick endLogPageView:eventId];
//}

- (void)showOffLineImage:(NSString *)imageName andLabelText:(NSString *)labelText andPoint:(CGPoint)point {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, image.size.width, image.size.height)];
    imageView.image = image;
    [self.view addSubview:imageView];
    UILabel *offLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x-40, point.y+120, 200, 30)];
    offLineLabel.text = labelText;
    offLineLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:offLineLabel];
}

#pragma mark - UITableView

- (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView cellID:(NSString *)cellID nibName:(NSString *)nibName
{
    UITableViewCell * customCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (customCell == nil) {
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                customCell = (UITableViewCell *)currentObject;
                break;
            }
        }
    }
    return customCell;
}

-(void)registerTableView:(UITableView *)tableView withCellNibName:(NSString *)nibName cellIdentifier:(NSString *)cellIdentifier
{
    UINib *nib=[UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
}

#pragma mark - Image

- (UIImage *)getSnapshotImage {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 0.0);
    [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSData * data = UIImagePNGRepresentation(image);
//    NSLog(@"skjfkasjdfkasdpath = %@",[NSString stringWithFormat:@"%@/Documents/ssss",NSHomeDirectory()]);
//    [data writeToFile:[NSString stringWithFormat:@"%@/Documents/ssss",NSHomeDirectory()] atomically:NO];
    return image;
}

-(UIImage *)getSnapshotImageByView:(UIView *)customView{
    UIGraphicsBeginImageContextWithOptions(customView.bounds.size, NO, 0.0);
    [customView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(UIViewController *)getSpecificClassWithName:(NSString *)className
{
    for (id controller in self.navigationController.viewControllers) {
        if ([[controller class] isKindOfClass:NSClassFromString(className)]) {
            return controller;
        }
    }
    return self.navigationController.viewControllers[0];
}


#pragma mark - ViewController
//从最底层向上层遍历

-(id)nextViewController:(id)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController * mvc = (UINavigationController *)vc;
        return [self nextViewController:[mvc.viewControllers lastObject]];
    }
    
    UIViewController * viewcontroller = (UIViewController *)vc;
    if (viewcontroller.presentedViewController == nil) {
        return viewcontroller;
    }
    return [self nextViewController:viewcontroller.presentedViewController];

}

/**
 *  获得当前正在显示的ViewController
 *
 *  @return 当前显示的ViewController类名
 */
-(UIViewController *)topMostViewController
{
    if ([[[[UIApplication sharedApplication] keyWindow] rootViewController] isKindOfClass:[UINavigationController class]]){
        
        UINavigationController * nav = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        return [self nextViewController:[nav.viewControllers lastObject]];
        
    }
    
    return [self nextViewController:[[[UIApplication sharedApplication] delegate] window].rootViewController];
}

//从UIStoryboard初始化UIViewController
- (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)storyboardId
                                           withStoryboardName:(NSString *)name {
    if (name.length == 0 || storyboardId.length == 0) {
        return nil;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    return controller;
}

- (UINavigationController *)instantiateNavControllerWithIdentifier:(NSString *)identifier
                                                withStoryboardName:(NSString *)name {
    if (name.length == 0 || identifier.length == 0) {
        return nil;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    //    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    //    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navController;
}

@end



