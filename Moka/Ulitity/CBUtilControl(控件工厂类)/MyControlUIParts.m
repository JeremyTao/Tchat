//  MyControl.h
//  LimitFreeDemo
//
//  Created by LongHuanHuan on 15/4/12.
//  Copyright (c) 2015年 ___LongHuanHuan___. All rights reserved.

#import "MyControlUIParts.h"
@implementation MyControlUIParts
#pragma mark 创建View
+(UIView*)createViewWithFrame:(CGRect)frame andBGColcor:(UIColor *)bgColor andRadius:(CGFloat)radius
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
   
    view.backgroundColor = bgColor;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    return view;
    
}
#pragma mark 创建label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //设置字体
    label.font=[UIFont systemFontOfSize:font weight:0.1];
    //设置折行方式 NSLineBreakByWordWrapping是按照单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //折行限制 0时候是不限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentCenter;
    //设置背景颜色
    label.backgroundColor=[UIColor clearColor];
    //设置文字
    label.text=text;
    //自适应
    //label.adjustsFontSizeToFitWidth=YES;
    return label;
}


#pragma mark 创建label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text andBgColor:(UIColor *)bgColor
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //设置字体
    label.font=[UIFont systemFontOfSize:font];
    //设置折行方式 NSLineBreakByWordWrapping是按照单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //折行限制 0时候是不限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    //设置背景颜色
    label.backgroundColor=[UIColor clearColor];
    //设置文字
    label.text=text;
    label.textColor = bgColor;
    //自适应
    label.adjustsFontSizeToFitWidth=YES;
    return label;
}
#pragma mark 创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method title:(NSString*)title andBG:(UIImage*)image andRadius:(CGFloat)radius andTitleColor:(UIColor *)tColor andtitleFont:(UIFont *)tFont
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame=frame;
    button.layer.cornerRadius = radius;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    [button setBackgroundImage:image forState:(UIControlStateSelected)];
    [button setBackgroundImage:image forState:(UIControlStateHighlighted)];

    [button setTitleColor:tColor forState:(UIControlStateNormal)];
    button.titleLabel.font = tFont;
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark 创建imageView
+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    //用户交互
    imageView.userInteractionEnabled=YES;
    return imageView;
}
#pragma mark 创建textField
+(UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    textField.font=[UIFont systemFontOfSize:font];
    textField.textColor=color;
    //左边的图片
    UIImage*image=[UIImage imageNamed:leftImageName];
    UIImageView*letfImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    textField.leftView=letfImageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右边的图片
    UIImage*rightImage=[UIImage imageNamed:rightImageName];
    UIImageView*rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rightImage.size.width, rightImage.size.height)];
    textField.rightView=rightImageView;
    textField.rightViewMode=UITextFieldViewModeAlways;
    //清除按钮
    textField.clearButtonMode=YES;
    
    //当再次编辑时候清除
    //textField.clearsOnBeginEditing=YES;
    
    
//    //密码遮掩
//    textField.secureTextEntry
//    //提示框
//    textField.placeholder
    return textField;

}
//适配器 为了适配以前的版本，和现有已经开发的所有功能模块，在原有功能模块基础上进行扩展的方式
+(UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName placeHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen
{
   UITextField*textField= [MyControlUIParts createTextFieldFrame:frame Font:font textColor:color leftImageName:leftImageName rightImageName:rightImageName bgImageName:bgImageName];
    //适配器扩展出来的方法
    textField.placeholder=placeHolder;
    textField.secureTextEntry=isOpen;
    return textField;
}

+(UITextView *)creatTextViewFrame:(CGRect)frame Font:(float)font texrColor:(UIColor *)color backGroundColor:(UIColor *)bGColor{
    
   UITextView *messageView = [[UITextView alloc] initWithFrame:frame];
    messageView.center = CGPointMake((SCREEN_WIDTH) / 2 , 130);
    messageView.backgroundColor = bGColor;
    messageView.textColor = color;
    messageView.font = [UIFont systemFontOfSize:font];
    messageView.layer.cornerRadius = 10;
    messageView.layer.masksToBounds = YES;
    messageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    messageView.layer.borderWidth = 1;
    
    
    return messageView;
}
+(UITextView *)creatMoreTextViewFrame:(CGRect)frame Font:(float)font texrColor:(UIColor *)color backGroundColor:(UIColor *)bGColor{
    
    UITextView *messageView = [[UITextView alloc] initWithFrame:frame];
    messageView.backgroundColor = bGColor;
    messageView.textColor = color;
    messageView.font = [UIFont systemFontOfSize:font];
    messageView.layer.cornerRadius = 8;
    messageView.layer.masksToBounds = YES;
    messageView.layer.borderColor = [UIColor colorWithRed:191 / 255.0  green:191 / 255.0  blue:191 / 255.0 alpha:1].CGColor;
    messageView.layer.borderWidth = 1;
    
    
    return messageView;
}
+(UIScrollView *)creatScrollerViewFrame:(CGRect)frame andSize:(CGSize)size andSet:(CGPoint)set{
    UIScrollView *photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    photoScrollView.contentSize = size;
    photoScrollView.showsHorizontalScrollIndicator = NO;
    photoScrollView.showsVerticalScrollIndicator = NO;
    photoScrollView.pagingEnabled = YES;
    photoScrollView.contentOffset = set;
    return photoScrollView;
}
+(void)getBoomLine:(UIButton *)sender andTitle:(NSString *)title{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [sender setAttributedTitle:str forState:UIControlStateNormal];
}

@end
