//
//  DBCommentView.m
//  DoBe
//
//  Created by liuxuan on 15/6/16.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCommentView.h"

@interface DBCommentView()<UITextFieldDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


@end


@implementation DBCommentView

- (void)awakeFromNib {
    
    self.backgroundColor = RGB(234, 234, 234);
    _textField.delegate = self;
    _textField.text = @"";
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.layer.borderWidth = 0.5f;
    _textField.layer.borderColor = kBorderColor.CGColor;
    _textField.layer.cornerRadius = 5.0f;
    
    _sendBtn.backgroundColor = kButtonBgColor;
    _sendBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)sendCommentEventClick:(UIButton *)sender {
    [_textField resignFirstResponder];
    if (_sendCommentBlock) {
        _sendCommentBlock(_textField.text, YES);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {    
    if (_sendCommentBlock) { //此时不发送 增加参数判断键盘如何收取
        _sendCommentBlock(_textField.text, NO);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setFirstResponder {
    if ([_textField canBecomeFirstResponder]) {
        [_textField becomeFirstResponder];
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
