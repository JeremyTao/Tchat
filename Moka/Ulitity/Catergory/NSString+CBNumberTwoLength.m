//
//  NSString+CBNumberTwoLength.m
//  CrunClub
//
//  Created by 郑克 on 16/4/22.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "NSString+CBNumberTwoLength.h"

@implementation NSString (CBNumberTwoLength)
+(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+(NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
    
    
}

+(NSString*)removeFloatAllZero:(CGFloat)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 20;
    NSString *result = [formatter stringFromNumber:@(number)];
    NSLog(@"%@", result);
    
    return result;
}

+ (NSString *)compareCurrentTime:(NSString *)str {
    
    //Tue Mar 08 13:14:45 +0800 2016  服务端获取时间的格式是这样的
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    //设置时区
    form.locale = [NSLocale localeWithLocaleIdentifier:@"cn"];
    form.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [form dateFromString:str];
    
    //得到当前的时间差
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //然后进行时间的比较
    if(timeInterval < 60)
    {
        return [NSString stringWithFormat:@"刚刚"];
    }
    //分钟
    NSInteger minute = timeInterval / 60;
    if(minute < 60)
    {
        return [NSString stringWithFormat:@"%ld分钟前",minute];
    }
    NSInteger hours = minute / 60;
    if(hours < 24)
    {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    NSInteger day = hours / 24;
    
    if(day <= 1)
    {
        form.dateFormat = @"HH:mm";
        NSString *oldtime = [form stringFromDate:date];
        return [NSString stringWithFormat:@"昨天 %@",oldtime];
    }
    else if(day < 7)
    {
        return [NSString stringWithFormat:@"%ld天前",day];
    }
    else
    {
        form.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *oldtime = [form stringFromDate:date];
        return [NSString stringWithFormat:@"%@",oldtime];
    }
    return nil;
}



@end
