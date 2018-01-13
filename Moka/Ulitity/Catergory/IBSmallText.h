//
//  IBSmallText.h
//  InnerBuy
//
//  Created by 郑克 on 16/5/5.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBSmallText : UITextField
/**
 *  边框宽度
 */
@property (assign, nonatomic)CGFloat borderWidth;
/**
 *  边框宽度
 */
-(void)setText;
-(void)clearText;
@end
