//
//  YCSegmentRoundButton.h
//  YCSegmentButton
//
//  Created by kk on 14-10-20.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCSegmentRoundButton : UIControl

@property (nonatomic,strong)UIImage * backgroundImage;
@property (nonatomic,strong)UIView * selectedStainView;
@property (nonatomic,strong)UIColor * segmentTextColor;
@property (nonatomic,strong)UIColor * selectedSegmentTextColor;
@property (nonatomic,assign)NSInteger selectedSegmentIndex;



-(id)initWithItems:(NSArray *)items;

-(NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

-(void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

-(void)removeAllSegments;

//-(void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated;
@end
