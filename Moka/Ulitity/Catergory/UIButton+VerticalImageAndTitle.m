//
//  UIButton+VerticalImageAndTitle.m
//  InnerBuy
//
//  Created by Knight on 08/10/2016.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "UIButton+VerticalImageAndTitle.h"

@implementation UIButton (VerticalImageAndTitle)

- (void)verticalImageAndTitle:(CGFloat)spacing
{
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
//    [self.titleLabel.text sizeWithAttributes:@[NSFontAttributeName:self.titleLabel.font];
    
//    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
//    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
//    if (titleSize.width + 0.5 < frameSize.width) {
//        titleSize.width = frameSize.width;
//    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

@end
