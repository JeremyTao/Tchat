//
//  UIBarButtonItem+Item.h
//  传智微博
//
//  Created by apple on 15-3-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
/**
 *  创建自定义的UIBarButtonItem
 *
 *  @param image
 *  @param highImage
 *  @param target
 *  @param action
 *  @param controlEvents
 *  @param title
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents andTitle:(NSString *)title andTitleColcor:(UIColor *)color andFrame:(CGRect)frame;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents andFrame:(CGRect)frame;

@end
