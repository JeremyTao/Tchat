//
//  UIImage+UISegmentIconAndText.m
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "UIImage+UISegmentIconAndText.h"

@implementation UIImage (UISegmentIconAndText)

+ (id) imageFromImage:(UIImage*)image string:(NSString*)string color:(UIColor*)color
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize expectedTextSize = [string sizeWithAttributes:@{NSFontAttributeName: font}];
    int width = expectedTextSize.width + image.size.width + 5;
    int height = MAX(expectedTextSize.height, image.size.width);
    CGSize size = CGSizeMake((float)width, (float)height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    int fontTopPosition = (height - expectedTextSize.height) / 2;
    CGPoint textPoint = CGPointMake(image.size.width + 5, fontTopPosition);
    
    [string drawAtPoint:textPoint withAttributes:@{NSFontAttributeName: font}];
    // Images upside down so flip them
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, (CGRect){ {0, (height - image.size.height) / 2}, {image.size.width , image.size.height } }, [image CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
