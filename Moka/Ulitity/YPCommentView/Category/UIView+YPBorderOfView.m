//
//  UIView+YPBorderOfView.m
//  YPCommentDemo
//
//  Created by 朋 on 16/7/22.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import "UIView+YPBorderOfView.h"

@implementation UIView (YPBorderOfView)

-(void)createBorderView{
    
    self.layer.borderWidth = 0.5;
    // 设置圆角
    self.layer.cornerRadius = 4.5;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 214.0/255.0, 214.0/255.0, 214.0/255.0, 1 });
    self.layer.borderColor = borderColorRef;
    
}

-(void)createKuangView{
    self.layer.borderWidth = 0.5;
    // 设置圆角
    //    self.layer.cornerRadius = 4.5;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 214.0/255.0, 214.0/255.0, 214.0/255.0, 1 });
    self.layer.borderColor = borderColorRef;
    
}


- (void)createTextViewBorder {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 169.0/255.0, 169.0/255.0, 169.0/255.0, 1 });
    self.layer.borderColor = borderColorRef ;
    
    self.layer.borderWidth =0.6;
    
    self.layer.cornerRadius =0.0;
}



@end
