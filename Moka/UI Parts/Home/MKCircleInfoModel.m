//
//  MKCircleInfoModel.m
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKCircleInfoModel.h"

@implementation MKCircleInfoModel

@synthesize id;

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"memberList" : @"MKCircleMemberModel",
             @"lableList"  : @"MKInterestTagModel"};
    
}


@end
