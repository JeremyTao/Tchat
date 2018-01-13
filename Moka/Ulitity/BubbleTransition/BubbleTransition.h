//
//  BubbleTransition.h
//  BubleTransitionDemo
//
//  Created by Knight on 8/18/16.
//  Copyright © 2016 Knight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BubbleTransitionModePresent,
    BubbleTransitionModeDismiss,
    BubbleTransitionModePop
} BubbleTransitionMode;

@interface BubbleTransition : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGPoint startingPoint;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BubbleTransitionMode transitionMode;
@property (nonatomic, strong) UIView  *bubble;
@property (nonatomic, strong) UIColor *bubbleColor;



@end
