//
//  CDGetImageSize.m
//  Exercise
//
//  Created by 郑克 on 16/2/19.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "CDGetImageSize.h"

@implementation CDGetImageSize
#pragma mark  根据尺寸来获得图片大小
#pragma mark - Api functions static

+ (NSURL *)getUpsImageUrl:(NSString *)originalImageUrl withCGSize:(CGSize)size
{
//    CGFloat scale = [UIScreen mainScreen].scale;
    
//    NSString* url = [NSString stringWithFormat:@"%@_%dx%d.jpg", originalImageUrl, (int)(size.width * scale),(int)(size.height * scale)];
    
    return [NSURL URLWithString:originalImageUrl];
}

+ (NSURL *)getupsLowImageUrl:(NSString *)originalImageUrl withCGSize:(CGSize)size
{
    NSString* url = [NSString stringWithFormat:@"%@_%dx%d.jpg", originalImageUrl, (int)(size.width),(int)(size.height)];
    
    return [NSURL URLWithString:url];
}

@end
