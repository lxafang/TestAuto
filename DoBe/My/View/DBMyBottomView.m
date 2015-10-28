//
//  DBMyBottomView.m
//  DoBe
//
//  Created by liuxuan on 15/6/10.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBMyBottomView.h"

@interface DBMyBottomView() {
    
}
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *nightModelBtn;
@property (weak, nonatomic) IBOutlet UIButton *feedBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@end


@implementation DBMyBottomView

- (void)awakeFromNib {
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*
    CGFloat gap = (kScreenWidth - 4*44)/5;
    _downloadBtn.frame = CGRectMake(gap, 20.0f, 44.0f, 44.0f);
    _nightModelBtn.frame = CGRectMake(_downloadBtn.right + gap, 20.0f, 44.0f, 44.0f);
    _feedBtn.frame = CGRectMake(_nightModelBtn.right + gap, 20.0f, 44.0f, 44.0f);
    _settingBtn.frame = CGRectMake(_feedBtn.right+gap, 20.0f, 44.0f, 44.0f);*/

}

- (IBAction)downloadClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    if (_bottomEventTypeBlock) {
        _bottomEventTypeBlock(tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*
Auto Layout 的本质原理

Auto Layout 的本质是用一些约束条件对元素进行约束，从而让他们显示在我们想让他们显示的地方。

约束主要分为以下几种（欢迎补充）：

相对于父 view 的约束。如：距离上边距 10，左边距 10。
相对于前一个元素的约束。如：距离上一个元素 20，距离左边的元素 5 等。
对齐类约束。如：跟父 view 左对齐，跟上一个元素居中对齐等。
相等约束。如：跟父 view 等宽。

三等分设计思路

许多人刚开始接触 Auto Layout，可能会以为它只能实现上面的1、2功能，其实后面3、4两个功能才是强大、特别的地方。接下来我们将尝试设计横向三等分：

第一个元素距离左边一定距离。
最后一个元素距离右边一定距离。
三者高度恒定，宽度相等。（此处我们设置为高度恒定（height 属性），如果你需要的是固定长宽比，则需要设定 Aspect Ratio 属性）
1和2、2和3的横向间距固定。*/

@end
