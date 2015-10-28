//
//  YCTextView.m
//  iWeidao
//
//  Created by 赵学智 on 14-7-25.
//  Copyright (c) 2014年 Weidao. All rights reserved.
//

#import "YCTextView.h"

@interface YCTextView()
{
    BOOL _shouldDrawPlaceholder;
}
- (void)_initialize;
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;
@end

@implementation YCTextView

- (void)setText:(NSString *)string {
    [super setText:string];
    [self _updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }

    _placeholder = string;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    [self setNeedsDisplay];
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_shouldDrawPlaceholder) {
        [_placeholderColor set];
        if (self.font) {
            [_placeholder drawWithRect:CGRectMake(8.0f, 18.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) options:0 attributes:@{NSFontAttributeName:self.font} context:nil];
        } else {
            [_placeholder drawWithRect:CGRectMake(8.0f, 18.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) options:0 attributes:nil context:nil];
        }
    }
}


#pragma mark - Private

- (void)_initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    _shouldDrawPlaceholder = NO;
}


- (void)_updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}


- (void)_textChanged:(NSNotification *)notificaiton {
    [self _updateShouldDrawPlaceholder];
}

@end
