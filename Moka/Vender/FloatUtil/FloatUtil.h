//
//  FloatUtil.h
//
//  Created by wenjq on 16-06-16.
//  Copyright 2016年 SFQ. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface FloatUtil : NSObject




/**
 *
 *  float类型就近转化为整型
 *
 */
+ (NSInteger)convertInterger:(float)f;


/**
 *
 *  float类型比较
 *
 *
 *  @return:
 *        0:相等，<0:fl<f2,>0:f1>f2
 */
+ (NSInteger)compare:(float) f1 f1:(float)f2;


/**
 *
 *  float类型截取:小数点后几位
 *
 */
+ (NSString*)sub:(float) f1 digit:(NSInteger)digit;


@end
