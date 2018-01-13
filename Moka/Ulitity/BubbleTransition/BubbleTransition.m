//
//  BubbleTransition.m
//  BubleTransitionDemo
//
//  Created by Knight on 8/18/16.
//  Copyright © 2016 Knight. All rights reserved.
//

#import "BubbleTransition.h"


@implementation BubbleTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startingPoint = CGPointZero;
        self.duration = 0.3;
        self.bubbleColor = [UIColor whiteColor];
        self.transitionMode = BubbleTransitionModePresent;
        self.bubble = [UIView new];
        
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    if (!containerView) {
        return;
    }
    
    if (self.transitionMode == BubbleTransitionModePresent) {
        UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
        CGPoint originalCenter = presentedControllerView.center;
        CGSize originalSize = presentedControllerView.frame.size;
        _bubble.frame = [self frameForBubbleWithOriginalCenter:originalCenter originalSize:originalSize startPonit:_startingPoint];
        _bubble.layer.cornerRadius = _bubble.frame.size.height / 2;
        _bubble.center = _startingPoint;
        _bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
        _bubble.backgroundColor = _bubbleColor;
        [containerView addSubview:_bubble];
        
        presentedControllerView.center = _startingPoint;
        presentedControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        presentedControllerView.alpha = 0;
        [containerView addSubview:presentedControllerView];
        
        [UIView animateWithDuration:_duration animations:^{
            self.bubble.transform = CGAffineTransformIdentity;
            presentedControllerView.transform = CGAffineTransformIdentity;
            presentedControllerView.alpha = 1;
            presentedControllerView.center = originalCenter;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        NSString *key = (_transitionMode == BubbleTransitionModePop) ? UITransitionContextToViewKey : UITransitionContextFromViewKey;
        UIView *returningControllerView = [transitionContext viewForKey:key];
        CGPoint originalCenter = returningControllerView.center;
        CGSize originalSize = returningControllerView.frame.size;
        _bubble.frame = [self frameForBubbleWithOriginalCenter:originalCenter originalSize:originalSize startPonit:_startingPoint];
        _bubble.layer.cornerRadius = _bubble.frame.size.height / 2;
        _bubble.center = _startingPoint;
        
        [UIView animateWithDuration:_duration animations:^{
            self.bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            returningControllerView.center = self.startingPoint;
            returningControllerView.alpha = 0;
            
            if (self.transitionMode == BubbleTransitionModePop) {
                [containerView insertSubview:returningControllerView belowSubview:returningControllerView];
                [containerView insertSubview:self.bubble belowSubview:returningControllerView];
            }
            
        } completion:^(BOOL finished) {
            returningControllerView.center = originalCenter;
            [returningControllerView removeFromSuperview];
            [self.bubble removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
    
}

- (CGRect)frameForBubbleWithOriginalCenter:(CGPoint)originalCenter
                              originalSize:(CGSize)originalSize
                                startPonit:(CGPoint)start {
    CGFloat lengthX = fmax(start.x, originalSize.width - start.x);
    CGFloat lengthY = fmax(start.y, originalSize.height - start.y);
    CGFloat offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
    CGSize size = CGSizeMake(offset, offset);
    return CGRectMake(0, 0, size.height, size.width);
    
}


@end
