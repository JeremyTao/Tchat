//
//  NSString+CBNumberTwoLength.h
//  CrunClub
//
//  Created by 郑克 on 16/4/22.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CBNumberTwoLength)
+(NSString *)notRounding:(float)price afterPoint:(int)position;
+(NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;
+(NSString*)removeFloatAllZero:(CGFloat)number;
+ (NSString *)compareCurrentTime:(NSString *)str;
@end
