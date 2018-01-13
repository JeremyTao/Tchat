//
//  LimitTextField.m
//  upinsong
//
//  Created by 张磊 on 15/3/16.
//  Copyright (c) 2015年 upinsong. All rights reserved.
//

#import "LimitTextField.h"

@interface LimitTextField()

@end

@implementation LimitTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if(self.limitLength > 0)
    {
        if (IOS8_2) {
            [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            
        }
        self.clearButtonMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self];
}

#pragma mark - textfield delegate

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    NSString *lang = textField.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"])
    { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.limitLength) {
                textField.text = [toBeString substringToIndex:self.limitLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.limitLength) {
            textField.text = [toBeString substringToIndex:self.limitLength];
        }
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSInteger strLength = textField.text.length - range.length + string.length;
//    return (strLength <= self.limitLength);
//}
@end
