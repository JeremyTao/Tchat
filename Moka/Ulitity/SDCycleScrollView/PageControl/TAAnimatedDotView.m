//
//  TAAnimatedDotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAAnimatedDotView.h"
#define WHITE_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]
#define BLACK_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

static CGFloat const kAnimateDuration = 0;

@implementation TAAnimatedDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (void)setDotColor:(UIColor *)dotColor
{
//    _dotColor = dotColor;
//    self.layer.borderColor  = dotColor.CGColor;
}

- (void)initialization
{
    _dotColor = [UIColor whiteColor];
    self.backgroundColor    = RGBCOLOR(220, 220, 220);
    self.layer.cornerRadius = 4;
//    NSLog(@"%f",self.layer.cornerRadius);
    self.layer.borderColor  = RGBCOLOR(220, 220, 220).CGColor;
    self.layer.borderWidth  = 0.6;
}


- (void)changeActivityState:(BOOL)active
{
    
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}


- (void)animateToActiveState
{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.backgroundColor = _dotColor;
        
        
        self.backgroundColor    = commonBlueColor;
        self.layer.borderColor  = commonBlueColor.CGColor;
//        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:nil];
}

- (void)animateToDeactiveState
{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = RGBCOLOR(220, 220, 220);
        self.layer.borderColor  = RGBCOLOR(220, 220, 220).CGColor;
//        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
