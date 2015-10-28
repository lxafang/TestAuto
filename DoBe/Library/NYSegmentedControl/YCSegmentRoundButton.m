//
//  YCSegmentRoundButton.m
//  YCSegmentButton
//
//  Created by kk on 14-10-20.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "YCSegmentRoundButton.h"


@interface DefaultStainView : UIView

@end


@interface YCSegmentRoundButton()

@property (nonatomic, strong) NSMutableArray * items;

@end


/**
 * 1、利用数组的enumerateObjectsUsingBlock:遍历其中的每个元素
 * 2、UIColor red ＝ UIColor.redColor;
 * 3、setNeedsLayOut
 * 4、MAX(MIN(segment, self.numberOfSegments - 1), 0);
 * 5、setNeedsDisplay自动调用drawRect，setNeedsLayout自动调用layoutSubviews
 */
@implementation YCSegmentRoundButton

+(Class)layerClass
{
    return CAShapeLayer.class;
}

-(id)init{

    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}


-(id)initWithItems:(NSArray *)items
{
    if (self = [self init]) {
        [items enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL *stop) {
            [self insertSegmentWithTitle:title atIndex:idx animated:NO];
        }];
    }
    return self;
}

-(void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segmentIndex animated:(BOOL)animated
{
    
    //创建Label
    UILabel * segmentView = [[UILabel alloc] init];
    segmentView.alpha = 0;
    segmentView.text = title;
    segmentView.textAlignment = NSTextAlignmentCenter;
    segmentView.textColor = self.segmentTextColor;
    segmentView.font = [UIFont boldSystemFontOfSize:15];
    segmentView.backgroundColor = UIColor.clearColor;
    segmentView.userInteractionEnabled = YES;
    [segmentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelect:)]];
    [segmentView sizeToFit];
    
    NSUInteger index = MAX(MIN(segmentIndex, [self numberOfSegments]), 0);
    
    if (index < self.items.count) {
        UIView * itemView = (UIView *)self.items[index];
        segmentView.center = itemView.center;
        [self insertSubview:segmentView aboveSubview:self.items[index]];
        [self.items insertObject:segmentView atIndex:index];
        
    }else {
        segmentView.center = self.center;
        [self addSubview:segmentView];
        [self.items addObject:segmentView];
    }
    //重新调整选中item的下标
    if (self.selectedSegmentIndex >= index) {
        self.selectedSegmentIndex ++;
    }
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutSubviews];
        }];
    }else{
        [self setNeedsLayout];
    }
}


-(NSUInteger)numberOfSegments
{
    return self.items.count;
}

-(void)layoutSubviews{
    
    
//    CGFloat totalItemWidth = 0;
//    for (UIView * item in self.items) {
//        float itemWidth = CGRectGetWidth(item.bounds);
//        totalItemWidth += itemWidth;
//    }
//    
//    CGFloat spaceLeft = CGRectGetWidth(self.bounds) -totalItemWidth;
//    CGFloat interItemSpace = spaceLeft / (CGFloat)(self.items.count + 1);
    
    
    CGFloat spaceLeft = 0;
    CGFloat interItemSpace = 0;
    CGFloat itemWidth = (self.width - spaceLeft*2)/ MAX(self.items.count, 1);
    
    CGFloat itemsValignCenter = CGRectGetHeight(self.bounds) / 2;
    
    __block CGFloat pos = interItemSpace + spaceLeft;
    [self.items enumerateObjectsUsingBlock:^(UIView * item, NSUInteger idx, BOOL *stop) {
        
        item.alpha = 1;
        [item sizeToFit];
        item.width = itemWidth;
        
        if (self.selectedSegmentIndex == idx) {
            
            item.center = CGPointMake(pos + CGRectGetWidth(item.bounds)/2, itemsValignCenter);
        }else{
            item.frame = CGRectMake(pos, 0, CGRectGetWidth(item.bounds), itemsValignCenter*2);
        }
        pos += CGRectGetWidth(item.bounds) + interItemSpace;
    }];
    
    if (self.selectedSegmentIndex == -1) {
        self.selectedStainView.hidden = NO;
        [self drawSelectedMaskAtPosition:-1];
        
    }else {
    
        UIView * selectedItem = self.items[self.selectedSegmentIndex];
        
        CGRect stainFrame = selectedItem.frame;
        stainFrame.size.width += 10;
        stainFrame.origin.x -= 5;
        stainFrame.size.height = self.height;
        stainFrame.origin.y = 0;
        
        self.selectedStainView.layer.cornerRadius = stainFrame.size.height /0.4;
        BOOL animated = !self.selectedStainView.hidden && !CGRectEqualToRect(self.selectedStainView.frame, CGRectZero);
        UIView.animationsEnabled = animated;
        [UIView animateWithDuration:animated ? 0.2:0 animations:^{
            self.selectedStainView.frame = stainFrame;
        } completion:^(BOOL finished) {
            for (UILabel * item in self.items) {
                if (item == selectedItem) {
                    item.textColor = self.selectedSegmentTextColor;
                }else {
                    item.textColor = self.segmentTextColor;
                }
            }
            [self drawSelectedMaskAtPosition:selectedItem.center.x];
        }];
        UIView.animationsEnabled = YES;
    }
    
}

-(void)removeAllSegments
{
    [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.items removeAllObjects];
    [self setNeedsLayout];
}

-(void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, [self numberOfSegments] -1), 0);
    UILabel * segmentView = self.items[index];
    segmentView.text = title;
    [segmentView sizeToFit];
    [self setNeedsLayout];
}

-(NSString *)titleForSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, [self numberOfSegments] -1), 0);
    UILabel * segmentView = self.items[index];
    return segmentView.text;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    super.backgroundColor = backgroundColor;
    CAShapeLayer * layer = (CAShapeLayer *)self.layer;
    layer.fillColor = backgroundColor.CGColor;
}

-(void)drawRect:(CGRect)rect
{
    if (self.backgroundImage) {
        [self.backgroundImage drawInRect:rect];
    }else {
        [super drawRect:rect];
    }
}

-(void)setSelectedStainView:(UIView *)selectedStainView
{
    selectedStainView.frame = _selectedStainView.frame;
    [self insertSubview:selectedStainView aboveSubview:_selectedStainView];
    [_selectedStainView removeFromSuperview];
    
    _selectedStainView = selectedStainView;
    [self setNeedsLayout];
}


-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self setNeedsDisplay];
}


-(void)commonInit
{
    
    _items = [[NSMutableArray alloc] init];
    _selectedSegmentIndex = -1;
    _segmentTextColor = [UIColor redColor];
    _selectedSegmentTextColor = [UIColor purpleColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
//    CAShapeLayer * layer  = (CAShapeLayer *)self.layer;
//    layer.fillColor = [UIColor brownColor].CGColor;
//    self.layer.backgroundColor = [UIColor orangeColor].CGColor;
//    self.layer.shadowColor = [UIColor yellowColor].CGColor;
//    self.layer.shadowRadius = 2;
//    self.layer.shadowOpacity = 0.6;
//    self.layer.shadowOffset = CGSizeMake(0, 1);
    
    //TODO:
    self.selectedStainView = [[DefaultStainView alloc] init];
    self.selectedStainView.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.selectedStainView];
    
}

//画边框
-(void)drawSelectedMaskAtPosition:(CGFloat)position
{
    if (self.backgroundImage == nil ) {
        UIBezierPath *path = UIBezierPath.new;
        CGRect bounds = self.bounds;
        [path moveToPoint:bounds.origin];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
        [path addLineToPoint:bounds.origin];
        
        CAShapeLayer* shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.borderColor = [UIColor brownColor].CGColor;
        shapeLayer.path = path.CGPath;
    }
}


-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        /**
         *  NSParameterAssert()只是一个宏，用于开发阶段调试程序中的bug，通过NSParameterAssert()传递条件表达式来判断时是否属于bug，满足条件返回真值，程序继续运行。返回假值，抛出异常。
         */
        NSParameterAssert(selectedSegmentIndex < self.items.count);
        _selectedSegmentIndex = selectedSegmentIndex;
        [self setNeedsLayout];
    }
}

-(void)handleSelect:(UIGestureRecognizer *)gestureRecognizer
{
    NSUInteger index = [self.items indexOfObject:gestureRecognizer.view];
    if (index != NSNotFound) {
        self.selectedSegmentIndex = index;
        [self setNeedsLayout];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}
@end


@implementation DefaultStainView

-(id)init{
    
    if (self = [super init]) {
        self.clipsToBounds = YES;
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0, 0) cornerRadius:self.layer.cornerRadius].CGPath;
    CGContextAddPath(context, roundedRect);
    CGContextClip(context);
    
    CGContextAddPath(context, roundedRect);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 3, UIColor.blackColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    CGContextStrokePath(context);
}
@end




























