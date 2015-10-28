//
//  DBBottomView.m
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBBottomView.h"
#import "JSBadgeView.h"

@interface DBBottomView() {
    CGSize _badgeSize;
}
@property (weak, nonatomic) IBOutlet UIButton *commentBtn; //tag 101 - 105
@property (weak, nonatomic) IBOutlet UIButton *commentCountBtn;


@end

@implementation DBBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    if (is_iphone5) {
        [_commentBtn setTitle:@"" forState:UIControlStateNormal];
//        [_commentBtn setImage:nil forState:UIControlStateNormal];
    }
    
    [_commentBtn.layer setBorderWidth:0.5f];
//    [_commentBtn.layer setBorderColor:kLightTextGray.CGColor];
    [_commentBtn.layer setBorderColor:kBorderColor.CGColor];
    _commentBtn.layer.cornerRadius = 5.0f;
    [_commentBtn.titleLabel setTextColor:kLightTextGray];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createSeperateLine];
}

- (IBAction)commentTouchUpInside:(id)sender {
    NSLog(@"写评论");
    UIButton *button = (UIButton *)sender;
    if (_bottomEventBlock) {
        _bottomEventBlock(button.tag);
    }
}

- (IBAction)lookCommentsTouchUpInside:(id)sender {
    NSLog(@"显示评论");
    UIButton *button = (UIButton *)sender;
    if (_bottomEventBlock) {
        _bottomEventBlock(button.tag);
    }
}

- (IBAction)collectTouchUpInside:(id)sender {
    NSLog(@"收藏");
    //tag 103
    UIButton *button = (UIButton *)sender;
    if (_bottomEventBlock) {
        _bottomEventBlock(button.tag);
    }
}

- (IBAction)shareTouchUpInside:(id)sender {
    NSLog(@"分享");
    UIButton *button = (UIButton *)sender;
    if (_bottomEventBlock) {
        _bottomEventBlock(button.tag);
    }
}

- (IBAction)moreEventTouchUpInside:(id)sender {
    NSLog(@"更多");
    UIButton *button = (UIButton *)sender;
    if (_bottomEventBlock) {
        _bottomEventBlock(button.tag);
    }
}

- (void)createSeperateLine
{
    UIImageView *seperateLine = [[UIImageView alloc] init];
    seperateLine.frame = CGRectMake(0.f, 0.f, self.width, 0.5f);
    seperateLine.image = [UIImage imageNamed:@"seperateline"];
    [self addSubview:seperateLine];
}

- (void)resetCommentCount:(NSInteger)commentCount {
    self.commentCount = commentCount;
    NSString *countStr = [NSString stringWithFormat:@"%ld",(long)_commentCount];
    /*
    _badgeSize = [countStr sizeWithFont:[UIFont systemFontOfSize:10.0f] boundSize:CGSizeMake(100, 20)];
    [self setNeedsDisplay];*/
    
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:_commentCountBtn alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeText = countStr;
    badgeView.badgeBackgroundColor = RGB(231, 85, 36);
    badgeView.badgeTextColor = [UIColor whiteColor];
    badgeView.badgeOverlayColor = [UIColor clearColor];
    badgeView.badgeTextFont = [UIFont systemFontOfSize:10.0f];
    badgeView.badgeTextShadowColor = [UIColor clearColor];
}


/*
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    return result;
}*/

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLine:context];
    [self drawSolidCircle:context];
    [self drawHollowCircle:context];
//     _commentCountBtn.layer.contentsRect
 }

//线
- (void)drawLine:(CGContextRef)context { //200 199 204
    CGContextSetStrokeColorWithColor(context, RGB(210, 210, 210).CGColor);//线条颜色
    CGContextSetLineWidth(context, 0.5);//线条宽度
    CGContextMoveToPoint(context, 0, 0); //开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(context, self.width, 0);//画直线, x，y 为线条结束点的坐标
    CGContextStrokePath(context); //开始画线
}


#define kMarginbadge 3.0f
//实心圆
-(void)drawSolidCircle:(CGContextRef)context
{   //画圆和椭圆 RGB(241, 151, 38) 0.6, 0.9, 0, 1.0
    CGFloat cWidth = 15.0f;
    
    if (_commentCount > 100 && _commentCount < 1000 ) {
        cWidth = _badgeSize.width + kMarginbadge;
    }
    
    CGContextSetRGBFillColor(context, 231/255.0f, 85/255.0f, 36/255.0f, 1);
    CGContextSetLineWidth(context, kMarginbadge);
    CGContextFillEllipseInRect(context, CGRectMake(_commentCountBtn.right - 8, _commentCountBtn.y - 5, cWidth, cWidth));
    //CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGFloat textX = _commentCountBtn.right - 8.f + (cWidth - _badgeSize.width)/2;
    CGFloat textY = _commentCountBtn.y - 5.0f + (cWidth - _badgeSize.height)/2;
    
    UIColor * magentaColor = [UIColor whiteColor];
    UIFont * helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    NSString *countStr = [NSString stringWithFormat:@"%ld",(long)_commentCount];
    [countStr drawInRect:CGRectMake(textX, textY, _badgeSize.width, _badgeSize.height)
          withAttributes:@{NSFontAttributeName: helveticaBold,
                           NSForegroundColorAttributeName: magentaColor
                           }];
}

//空心圆
- (void)drawHollowCircle:(CGContextRef)context {
    CGContextSetRGBStrokeColor(context, 231/255.0f, 85/255.0f, 36/255.0f, 1.0f);
    CGContextSetLineWidth(context, 0.5f);
    CGContextStrokeEllipseInRect(context, _commentCountBtn.frame);
    CGContextStrokePath(context);
}*/

@end
