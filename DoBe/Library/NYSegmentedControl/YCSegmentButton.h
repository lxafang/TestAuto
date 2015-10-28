//
//  YCSegmentButton.h
//  TestSegmentButton
//
//  Created by kk on 14-7-9.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonPressedBlock)(NSInteger index);

@interface YCSegmentButton : UIImageView

@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) NSArray * imagesArray;
@property (nonatomic,strong) NSArray * selectedImageNSArray;

@property (nonatomic,assign) NSInteger selectedIndex;//选中的的index
@property (nonatomic,strong) UIColor * selectedColor;
@property (nonatomic,strong) UIColor * unselectedColor;
@property (nonatomic,strong) UIColor * selectedBgColor;
@property (nonatomic,strong) UIFont  * customFont;
@property (nonatomic,assign) segmentButtonType btnShap;

@property (nonatomic,copy)  ButtonPressedBlock btnPressedBlock;

-(id)initWithTitles:(NSArray *)titlesArray type:(segmentButtonType)type;
-(id)initWithImagesArray:(NSArray *)imagesArray;
-(void)setIndex:(NSInteger)selectedIndex;


@end
