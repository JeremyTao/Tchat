//
//  MKUserInfoRootModel.m
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUserInfoRootModel.h"

@implementation MKUserInfoRootModel
@synthesize id;

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"mylableList" : @"MKInterestTagModel",
             @"foodList"    : @"MKInterestTagModel",
             @"motionList"  : @"MKInterestTagModel",
             @"filmList"    : @"MKInterestTagModel",
             @"portrailList": @"MKPortraitModel" };
    
}


@end
