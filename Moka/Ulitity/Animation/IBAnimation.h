//
//  IBAnimation.h
//  InnerBuy
//
//  Created by 郑克 on 16/5/11.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBAnimation : NSObject
/**button放大缩小动画*/
+ (void)playBounceAnimation:(UIButton *)icon andDuration:(int)duration;
/**button放大翻转动画*/
+ (void)playRotaionAnimation:(UIView *)icon andDuration:(int)duration;
/**lable动画*/
+ (void)playLabelAnimation:(UILabel *)label andDuration:(int)duration;
/**lable动画*/
+ (void)playDeselectLabelAnimation:(UILabel *)label andDuration:(int)duration;
@end
