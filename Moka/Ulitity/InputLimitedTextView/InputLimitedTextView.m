//
//  InputLimitedTextView.m
//  CrunClub
//
//  Created by Knight on 16/7/14.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "InputLimitedTextView.h"

@implementation InputLimitedTextView


{
    BOOL isReachedLimiteLength;
    UILabel *placeHolderLabel;
}

@synthesize placeholder = _placeholder;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:self];
    isReachedLimiteLength = NO;
    //设置光标颜色
    self.tintColor = [UIColor colorWithRed:0.454 green:0.454 blue:0.454 alpha:1.00];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textViewEditChanged:(NSNotification *)obj
{
    
    UITextView * textView = (UITextView *)obj.object;
    NSString * shownText = textView.text;
    if (shownText.length < self.limitLength) {
        isReachedLimiteLength = NO;
    }
    
    NSString *toBeString = textView.text;
    NSString *lang = textView.textInputMode.primaryLanguage;// 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        if (isReachedLimiteLength) {
            NSString * newText = [textView textInRange:selectedRange];
//            NSLog(@"%@", newText);
            if(newText.length > 0) {
                [textView replaceRange:selectedRange withText:@""];
                textView.text = [toBeString substringToIndex:self.limitLength];
            }
        }
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.limitLength) {
                textView.text = [toBeString substringToIndex:self.limitLength];
                isReachedLimiteLength = YES;
            } 
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.limitLength) {
            textView.text = [toBeString substringToIndex:self.limitLength];
            
        }
    }
    self.remindCharacterNumber = toBeString.length;
}

-(void)refreshPlaceholder
{
    if([[self text] length])
    {
        [placeHolderLabel setAlpha:0];
    }
    else
    {
        [placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [placeHolderLabel sizeToFit];
    placeHolderLabel.frame = CGRectMake(5, 10, CGRectGetWidth(self.frame)-16, CGRectGetHeight(placeHolderLabel.frame));
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if ( placeHolderLabel == nil )
    {
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = self.font;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        placeHolderLabel.alpha = 0;
        [self addSubview:placeHolderLabel];
    }
    
    placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}


@end
