//
//  YPTextView.h
//  YPCommentDemo
//
//  Created by 朋 on 16/7/22.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPTextView : UITextView
@property (nonatomic, copy) NSString *placehoder;
@property (nonatomic, strong) UIColor *placehoderColor;
@property (nonatomic, weak) UILabel *placehoderLabel;
/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;

/**
 *  控制TextView长度
 */
@property (assign, nonatomic) NSInteger limitLength;
// 输入字符串的长度
@property (assign, nonatomic) NSInteger remindCharacterNumber;
@end
