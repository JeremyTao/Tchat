//
//  InputLimitedTextView.h
//  CrunClub
//
//  Created by Knight on 16/7/14.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputLimitedTextView : UITextView

/**
 *  控制TextView长度
 */
@property (assign, nonatomic) NSInteger limitLength;
// 输入字符串的长度
@property (assign, nonatomic) NSInteger remindCharacterNumber;

@property(nullable, nonatomic,copy) IBInspectable NSString  *placeholder;

@end
