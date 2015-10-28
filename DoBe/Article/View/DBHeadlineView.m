//
//  DBHeadlineView.m
//  AutoLayoutDemo
//
//  Created by liuxuan on 15/6/5.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBHeadlineView.h"

@interface DBHeadlineView () {
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DBHeadlineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadWebView {
    if (_htmlString.length > 0) {
        [_webView loadHTMLString:_htmlString baseURL:nil];
        _webView.scalesPageToFit = YES;
    }
}

- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    [self loadWebView];
}

- (IBAction)testButton:(id)sender {
    NSLog(@"testButton");
}

- (void)drawRect:(CGRect)rect {
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //[self drawCircle:context];
}

- (void)drawCircle:(CGContextRef)context {
    CGContextSetRGBFillColor(context, 0.6, 0.9, 0, 1);
    CGContextSetLineWidth(context, 3.0);
    CGContextFillEllipseInRect(context, CGRectMake(0, 5, 30, 30));//在这个框中画圆
    CGContextStrokePath(context);
    
    UIColor * magentaColor = [UIColor redColor];
    UIFont * helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    NSString *countStr = @"10";
    [countStr drawInRect:CGRectMake(0, 5, 15, 15)
          withAttributes:@{NSFontAttributeName: helveticaBold,
                           NSForegroundColorAttributeName: magentaColor
                           }];
}
 


@end
