//
//  MKGradientButton.m
//  Moka
//
//  Created by Knight on 2017/7/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGradientButton.h"

@implementation MKGradientButton


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self drawGradientLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self drawGradientLayer];
}


- (void)drawGradientLayer {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)RGB_COLOR_HEX(0xa58dff).CGColor,(__bridge id)RGB_COLOR_HEX(0x7894f9).CGColor];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    [self.layer addSublayer:gradientLayer];

}

@end
