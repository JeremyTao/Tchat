//
//  FloatUtil.m
//
//  Created by wenjq on 16-06-16.
//  Copyright 2016年 SFQ. All rights reserved.
//

#import "FloatUtil.h"

@implementation FloatUtil


/**
 *
 *  float类型就近转化为整型
 *
 *  @param:
 *        sn:
 *
 *  @return:
 *        YES／NO
 */
+ (NSInteger)convertInterger:(float)f
{
    NSInteger a;
    a = (NSInteger)(f+0.5);
    
    return a;
}


/**
 *
 *  float类型比较
 *
 *  @param:
 *        f1:值1，f2:值2
 *
 *  @return:
 *        0:相等，<0:fl<f2,>0:f1>f2
 */
+ (NSInteger)compare:(float) f1 f1:(float)f2
{
    NSNumber *a=[NSNumber numberWithFloat:f1];
    NSNumber *b=[NSNumber numberWithFloat:f2];
    if ([a compare:b]==NSOrderedAscending)
    {
        return -1;
    }
    else if([a compare:b]== NSOrderedSame)
    {
        return 0;
        
    }
    else
    {
        return 1;
    }
    
}


/**
 *
 *  float类型截取:小数点后几位
 *
 *  @param:
 *        f1:值1，digit:位数
 *
 *  @return:
 *        截取后的字符串
 */
+ (NSString*)sub:(float) f1 digit:(NSInteger)digit
{
    NSString* format = [NSString stringWithFormat:@"%@%ld%@", @"%", (long)digit, @"f"];
    NSString *str=[NSString stringWithFormat:format, f1];
    return str;
    
}




@end
