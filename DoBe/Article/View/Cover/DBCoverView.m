//
//  DBCoverView.m
//  DoBe
//
//  Created by liuxuan on 15/6/14.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCoverView.h"
#import "DBCoverBottomView.h"
#import "DBCoverCell.h"
#import "YCSegmentButton.h"

@interface DBCoverView()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@end


@implementation DBCoverView

- (void)awakeFromNib {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
    _finishBtn.layer.borderWidth = 0.5f;
    _finishBtn.layer.borderColor = kBorderColor.CGColor;
    _finishBtn.layer.cornerRadius = 5.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SettingCoverCellID";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    NSInteger row = indexPath.row;
    [cell.textLabel setFont:kNormalFont];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon_set_night"];
        [cell.textLabel setText:@"夜间模式"];
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.onImage = [UIImage imageNamed:@"icon_set_on"];
        switchView.offImage = [UIImage imageNamed:@"icon_set_off"];
        [switchView addTarget:self action:@selector(switchDayOrNightMode:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }else if(row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"icon_set_fontsize"];
        [cell.textLabel setText:@"字体大小"];
        cell.accessoryView = [self creatSegmentButton];
    }else {
        DBCoverCell *coverCell = [[NSBundle mainBundle] loadNibNamed:@"DBCoverCell" owner:self options:nil][0];
        coverCell.selectionStyle = UITableViewCellSelectionStyleNone;
        coverCell.coverCellEventBlock = ^(NSInteger tag) {
            if (_coverBottomBlock) {
                _coverBottomBlock(tag);
            }
        };
        return coverCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        return 106.0f;
    }
    return 75.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0.f, 20.0f, 0.f, 20.0f)];
    }
}

- (YCSegmentButton *)creatSegmentButton {
    NSArray *typeList = @[@"小", @"中", @"大", @"超大"];
    YCSegmentButton *fontTypeBtn = [[YCSegmentButton alloc] initWithTitles:typeList type:plain];
    fontTypeBtn.layer.masksToBounds = YES;
    fontTypeBtn.layer.borderColor = kLightTextGray.CGColor;
    fontTypeBtn.layer.borderWidth = 0.5f;
    fontTypeBtn.layer.cornerRadius = 5.0f;
    fontTypeBtn.frame = CGRectMake(0.f, 0.f, 184.0f, 33.0f);
    fontTypeBtn.unselectedColor = [UIColor blackColor];
    fontTypeBtn.selectedColor = [UIColor whiteColor];
    fontTypeBtn.selectedBgColor = RGB(240, 94, 32);
    fontTypeBtn.customFont = kNormalFont;
    fontTypeBtn.selectedIndex = 1;
    __weak typeof(self)weakSelf = self;
    fontTypeBtn.btnPressedBlock = ^(NSInteger index) {
        NSLog(@"%@",typeList[index]);
        weakSelf.coverFontSizeBlock(index);
    };
    return fontTypeBtn;
}

/*
-(YCSegmentButton *)creatSegmentButton
{
    YCSegmentButton * cityTypeSelectBtn = [[YCSegmentButton alloc] initWithTitles:
                                           [NSArray arrayWithObjects: kCurrentLanguageForKey(@"SegmentButton_Home"),kCurrentLanguageForKey(@"SegmentButton_Foreign"),nil] type:plain];
    cityTypeSelectBtn.frame = CGRectMake((self.SegmentBtnHoldview.width - 290) / 2, (self.SegmentBtnHoldview.height - 29) / 2, 290, 29);
    UIImage * bgImage =[UIImage imageNamed:@"segmentNormal"];
    cityTypeSelectBtn.image = [bgImage stretchableImageWithLeftCapWidth:13 topCapHeight:5];
    cityTypeSelectBtn.selectedColor = [UIColor whiteColor];
    cityTypeSelectBtn.unselectedColor = [UIColor redColor];
    
    __weak typeof(self)weakSelf = self;
    cityTypeSelectBtn.btnPressedBlock = ^(NSInteger index){
        if (index == 0) {
            mCityType = Domestic;
        } else if (index ==1){
            mCityType = Foreign;
        }
        [[weakSelf cityListTableView] reloadData];
    };
    
    NSInteger defalutSegmentIndex = _isInlandCity ? 0 : 1;
    [cityTypeSelectBtn setSelectedIndex:defalutSegmentIndex];
    return cityTypeSelectBtn;
}*/


/* row=3 方案II 得单独处理分隔线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 106.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DBCoverBottomView *bottomView = [[NSBundle mainBundle] loadNibNamed:@"DBCoverBottomView" owner:self options:nil][0];
    bottomView.frame = CGRectMake(0.f, 1.0f, kScreenWidth, 106.0f);
    bottomView.coverBottomEventBlock = ^(NSInteger tag) {
        if (_coverBottomBlock) {
            _coverBottomBlock(tag);
        }
    };
    return bottomView;
}*/

#pragma mark - event

- (IBAction)finishEventClick:(UIButton *)sender {
    if (_coverFinishBlock) {
        _coverFinishBlock();
    }
}

- (void)switchDayOrNightMode:(UISwitch *)switchView {
    if ([switchView isOn]) {
        NSLog(@"夜间模式");
    }else {
        NSLog(@"白天模式");
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
