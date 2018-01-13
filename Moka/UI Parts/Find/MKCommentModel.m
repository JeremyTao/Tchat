//
//  MKCommentModel.m
//  Moka
//
//  Created by  moka on 2017/8/9.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKCommentModel.h"

@implementation MKCommentModel

@synthesize id;

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"dataList" : @"MKReplyModel"};
    
}

@end
