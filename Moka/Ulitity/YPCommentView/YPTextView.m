//
//  YPTextView.m
//  YPCommentDemo
//
//  Created by 朋 on 16/7/22.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import "YPTextView.h"
#import "UIView+YPBorderOfView.h"

@implementation YPTextView{
    BOOL isReachedLimiteLength;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTexiView];
        [self setup];
    }
    return self;
}
- (void)setup {
    
    _placeHolderTextColor = [UIColor lightGrayColor];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:15.0f];
    self.textColor = [UIColor colorWithWhite:0.35 alpha:1.000];
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
    self.layer.cornerRadius = 6;
    [self createTextViewBorder];
    [self.layer setMasksToBounds:YES];
}



- (void)awakeFromNib
{
    [self setupTexiView];
}

- (void)setupTexiView
{
    self.backgroundColor = [UIColor clearColor];
    UILabel *placehoderLabel = [[UILabel alloc] init];
    placehoderLabel.numberOfLines = 0;
    placehoderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:placehoderLabel];
    self.placehoderLabel = placehoderLabel;
    self.placehoderColor = [UIColor lightGrayColor];
    self.font = [UIFont systemFontOfSize:14];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self];

}

#pragma mark - 监听文字改变
-(void)textViewEditChanged:(NSNotification *)obj
{
    self.placehoderLabel.hidden = (self.text.length != 0);
    
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
-(void)textDidChange{
    self.placehoderLabel.hidden = (self.text.length != 0);

}
#pragma mark - 公共方法
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    self.placehoderLabel.text = placehoder;
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placehoderLabel.font = font;
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.placehoderLabel.frame;
    frame.origin.y = 8;
    frame.origin.x = 5;
    frame.size.width = self.frame.size.width - 2 * frame.origin.x;
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placehoderLabel.frame.size.width, MAXFLOAT);
    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLabel.font constrainedToSize:maxSize];
    frame.size.height = placehoderSize.height;
    self.placehoderLabel.frame = frame;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
