//
//  MKPeopleRootModel.m
//  Moka
//
//  Created by  moka on 2017/8/8.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKPeopleRootModel.h"

@implementation MKPeopleRootModel

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
