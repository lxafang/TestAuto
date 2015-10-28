//
//  YCSegmentButton.m
//  TestSegmentButton
//
//  Created by kk on 14-7-9.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "YCSegmentButton.h"
#define BASE_BUTTONTAG 100

@interface YCSegmentButton ()

@property (nonatomic,assign) BOOL isNeedSetTitle;

@end
@implementation YCSegmentButton

-(id)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(id)initWithTitles:(NSArray *)titlesArray type:(segmentButtonType)type
{
    self = [self init];
    if (!titlesArray) {
    }
    _btnShap = type;
    _isNeedSetTitle = YES;
    self.titleArray = titlesArray;
    [self creatButtonsWithArray:self.titleArray];
    
    return self;
}

-(id)initWithImagesArray:(NSArray *)imagesArray
{
    if (!imagesArray) {
    }
    _isNeedSetTitle = NO;
    self.imagesArray  = imagesArray;
    [self creatButtonsWithArray:self.imagesArray];
    return self;
}

- (void)setIndex:(NSInteger)selectedIndex
{
    [self resetAllButtons];
    if (_isNeedSetTitle) {
        UIButton * titleBtn = (UIButton *)[self viewWithTag:BASE_BUTTONTAG + selectedIndex];
        titleBtn.selected = YES;
        [titleBtn setTitleColor:_selectedColor forState:UIControlStateSelected];
        if (_selectedBgColor) {
            [titleBtn setBackgroundColor:_selectedBgColor];
        }else {
            [titleBtn setBackgroundColor:[UIColor redColor]];
        }
        
    } else {
        UIButton *btn = (UIButton *)[self viewWithTag:BASE_BUTTONTAG + selectedIndex];
        [btn setImage:self.selectedImageNSArray[selectedIndex] forState:UIControlStateSelected];
        if (_selectedBgColor) {
            [btn setBackgroundColor:_selectedBgColor];
        }else {
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setIndex:selectedIndex];
    if (self.btnPressedBlock) {
        self.btnPressedBlock(selectedIndex);
    }
}

#pragma mark - private method

-(void)creatButtonsWithArray:(NSArray *)tmpArray
{
    NSInteger segmentCount = tmpArray.count;
    for (int i = 0; i < segmentCount; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectZero;
        btn.tag = BASE_BUTTONTAG + i;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    //设置标题
    if ([[tmpArray lastObject] isKindOfClass:[NSString class]]) {
        for (int i = 0 ; i < tmpArray.count; i++) {
            
            UIButton * tmpBtn = (UIButton *)[self viewWithTag:BASE_BUTTONTAG + i];
            [tmpBtn setTitle:tmpArray[i] forState:UIControlStateNormal];
            if (!_customFont) {
                _customFont = [UIFont systemFontOfSize:13.0f];
            }
            tmpBtn.titleLabel.font = _customFont;
            [tmpBtn setTitleColor:_unselectedColor forState:UIControlStateNormal];
            tmpBtn.selected = NO;
            UIImage * imag = nil;
            if (i == 0) {
                if (self.btnShap == rounded) {
                   UIImage * tmpImage = [UIImage imageNamed:@"segmentRoundSelect"];
                   imag  = [tmpImage stretchableImageWithLeftCapWidth:15 topCapHeight:0];
                }else if(self.btnShap == plain){
                    UIImage * tmpImage = [UIImage imageNamed:@"segmentPlainSelect_home"];
                    imag  = [tmpImage stretchableImageWithLeftCapWidth:10 topCapHeight:5];
                }
            [tmpBtn setBackgroundImage:imag forState:UIControlStateSelected];
            }
            else if (i == 1){
                if (self.btnShap == rounded) {
                    UIImage * tmpImage = [UIImage imageNamed:@"segmentRoundSelect"];
                    imag  = [tmpImage stretchableImageWithLeftCapWidth:15 topCapHeight:0];
                }else if(self.btnShap == plain){
                    UIImage * tmpImage = [UIImage imageNamed:@"segmentPlainSelect_foregin"];
                    imag  = [tmpImage stretchableImageWithLeftCapWidth:10 topCapHeight:5];
                }
                [tmpBtn setBackgroundImage:imag forState:UIControlStateSelected];
            }
        }
    }else if([[tmpArray lastObject] isKindOfClass:[UIImage class]]) {
        //图片数组
        for (int i = 0 ; i < tmpArray.count; i++) {
            UIButton * tmpBtn = (UIButton *)[self viewWithTag:BASE_BUTTONTAG + i];
            [tmpBtn setImage:tmpArray[i] forState:UIControlStateNormal];
        }
    }
}

-(void)resetAllButtons
{
    for (id subview in self.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    if (_isNeedSetTitle) {
        [self creatButtonsWithArray:self.titleArray];
    } else {
        [self creatButtonsWithArray:self.imagesArray];
    }
}
-(void)btnPressed:(UIButton *)btn
{
    [self setSelectedIndex:btn.tag-BASE_BUTTONTAG];
//    _btnPressedBlock(btn.tag-BASE_BUTTONTAG);
}

- (void)layoutSubviews
{
    NSInteger count = _titleArray.count;
    for (int i = 0 ; i < count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:BASE_BUTTONTAG + i];
        btn.frame = CGRectMake(i * self.frame.size.width/count, 0, self.frame.size.width/count , self.frame.size.height);
        if (i > 0 && i < count - 1) {
            btn.layer.borderWidth = 0.25f;
            btn.layer.borderColor = kLightTextGray.CGColor;
        }
    }
}

@end
