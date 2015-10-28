//
//  DBCommentBottomView.m
//  DoBe
//
//  Created by liuxuan on 15/6/16.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCommentBottomView.h"

@interface DBCommentBottomView()<UITextFieldDelegate> {
    
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UIButton *sendBtn;
    __weak IBOutlet UIButton *cameraBtn;
}

@end

@implementation DBCommentBottomView

- (void)awakeFromNib {
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.layer.borderWidth = 0.5f;
    _textField.layer.borderColor = kBorderColor.CGColor;
    _textField.layer.cornerRadius = 5.0f;
    
    
}

- (IBAction)cameraEventClick:(UIButton *)sender {
    if (_cameraEventBlock) {
        _cameraEventBlock();
    }
}

- (IBAction)sendMessageEventClick:(UIButton *)sender {
    [_textField resignFirstResponder];
    if (_sendEventBlock) {
        _sendEventBlock(_textField.text, YES);
    }
}

/*
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_sendEventBlock) {
        _sendEventBlock(_textField.text, NO);
    }
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (_sendEventBlock) {
        _sendEventBlock(_textField.text, NO);
    }
    return YES;
}

- (void)setFieldText:(NSString *)text {
    _textField.text = text;
}

- (void)setFieldResignFirstResponder {
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
        
        if (_sendEventBlock) {
            _sendEventBlock(_textField.text, NO);
        }
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
