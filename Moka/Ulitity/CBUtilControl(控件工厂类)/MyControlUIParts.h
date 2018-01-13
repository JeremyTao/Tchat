//  MyControl.h
//  LimitFreeDemo
//
//  Created by LongHuanHuan on 15/4/12.
//  Copyright (c) 2015年 ___LongHuanHuan___. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyControlUIParts : NSObject
//使用+方法进行创建 是工厂模式中的一种
//工厂模式：传入参数，出来控件
/**创建View*/
+(UIView*)createViewWithFrame:(CGRect)frame andBGColcor:(UIColor *)bgColor andRadius:(CGFloat)radius;

/**创建label*/
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text;
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text andBgColor:(UIColor *)bgColor;
/**创建button*/
+(UIButton*)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method title:(NSString*)title andBG:(UIImage*)image andRadius:(CGFloat)radius andTitleColor:(UIColor *)tColor andtitleFont:(UIFont *)tFont;

/**创建imageView*/
+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName;
/**创建textField*/
+(UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName placeHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen;



/**
 *  创建textField
 *
 *  @param frame
 *  @param font
 *  @param color
 *  @param bGColor
 *
 *  @return UITextView
 */
+(UITextView *)creatTextViewFrame:(CGRect)frame Font:(float)font texrColor:(UIColor *)color backGroundColor:(UIColor *)bGColor;
+(UITextView *)creatMoreTextViewFrame:(CGRect)frame Font:(float)font texrColor:(UIColor *)color backGroundColor:(UIColor *)bGColor;
/**
 *  创建ScrollerView
 *
 *  @param frame
 *  @param size
 *  @param set
 *
 *  @return 
 */
+(UIScrollView *)creatScrollerViewFrame:(CGRect)frame andSize:(CGSize)size andSet:(CGPoint)set;
/**
 *  对button加下划线
 *
 *  @param sender sender description
 *  @param title  title description
 */
+(void)getBoomLine:(UIButton *)sender andTitle:(NSString *)title;
@end
