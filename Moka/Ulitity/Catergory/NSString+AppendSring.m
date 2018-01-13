//
//  NSString+AppendSring.m
//  InnerBuy
//
//  Created by Knight on 13/10/2016.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "NSString+AppendSring.h"



@implementation NSString (AppendSring)

+ (NSString *)JoinedWithSubStrings:(NSString *)firstStr,...NS_REQUIRES_NIL_TERMINATION{
    
    NSMutableArray *array = [NSMutableArray new];
    
    va_list args;
    
    if(firstStr){
        
        [array addObject:firstStr];
        
        va_start(args, firstStr);
        
        id obj;
        
        while ((obj = va_arg(args, NSString* ))) {
            [array addObject:obj];
        }
        
        va_end(args);
    }
    
    
    return [array componentsJoinedByString:@""];
    
}

//汉字转拼音，NSString的分类
+(NSString *)lowercaseSpellingWithChineseCharacters:(NSString *)chinese {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:chinese];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //返回小写拼音
    return [str lowercaseString];
}


@end
