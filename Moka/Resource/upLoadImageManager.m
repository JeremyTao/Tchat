//
//  upLoadImageManager.m
//  Moka
//
//  Created by btc123 on 2018/1/9.
//  Copyright © 2018年 moka. All rights reserved.
//

#import "upLoadImageManager.h"

@implementation upLoadImageManager

+(NSString *)judgeThePathForImages:(NSString *)imagePath{
    
    if ([imagePath hasPrefix:@"alioss_"]) {
        
        return [NSString stringWithFormat:@"%@%@%@", WAP_IMAGE_URL,IMG_URL, imagePath];
    }else{
        
        return [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, imagePath];
    }
}

@end
