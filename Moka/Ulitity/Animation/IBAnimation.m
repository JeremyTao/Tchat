//
//  IBAnimation.m
//  InnerBuy
//
//  Created by 郑克 on 16/5/11.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "IBAnimation.h"
@interface IBAnimation()

@property (nonatomic,assign) int duration;

@end
@implementation IBAnimation
+ (void)playBounceAnimation:(UIButton *)icon andDuration:(int)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.values = @[@(1), @(1.5), @(0.9), @(0.5), @(0.5), @(1)];
    animation.duration = 0.5;
    animation.calculationMode = kCAAnimationCubic;
    
    [icon.layer addAnimation:animation forKey:@"playBounceAnimation"];
}
+ (void)playRotaionAnimation:(UIView *)icon andDuration:(int)duration
{
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//    
//    animation.values = @[@(0), @(M_PI_2), @(M_PI), @(M_PI * 2)];
//    animation.duration = duration;
//    animation.calculationMode = kCAAnimationCubic;
//    
//    [icon.layer addAnimation:animation forKey:@"playRotaionAnimation"];
    
    
    [UIView transitionWithView:icon duration:0.6 options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionRepeat animations:^{
        //[UIView setAnimationRepeatCount:20]; // **This should appear in the beginning of the block*
        
    } completion:nil];

}

//动画
+ (void)playLabelAnimation:(UILabel *)label andDuration:(int)duration
{
    CAKeyframeAnimation *postionAnimation = [self createAnimation:@"position.y" duration:duration values:@[@(0), @(label.center.y)]];
    
    CAKeyframeAnimation *scaleAnimation = [self createAnimation:@"transform.scale" duration:duration values:@[@(2), @(1)]];
    
    CAKeyframeAnimation *opacityAnimation = [self createAnimation:@"opacity" duration:duration values:@[@(0), @(1)]];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[postionAnimation, scaleAnimation, opacityAnimation];
    
    [label.layer addAnimation:animationGroup forKey:@"playLabelAnimation"];
}

+ (void)playDeselectLabelAnimation:(UILabel *)label andDuration:(int)duration
{
    CAKeyframeAnimation *postionAnimation = [self createAnimation:@"position.y" duration:duration values:@[@(label.center.y + 15), @(label.center.y)]];
    
    CAKeyframeAnimation *opacityAnimation = [self createAnimation:@"opacity" duration:duration values:@[@(0), @(1)]];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[postionAnimation, opacityAnimation];
    
    [label.layer addAnimation:animationGroup forKey:@"playDeselectLabelAnimation"];
}

+ (CAKeyframeAnimation *)createAnimation:(NSString *)keyPath duration:(CGFloat)duration values:(NSArray *)values
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    animation.values = values;
    animation.duration = duration;
    animation.calculationMode = kCAAnimationCubic;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    
    return animation;
}

@end
