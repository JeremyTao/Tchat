//
//  NSRegularExpression+IBTopicRegex.m
//  InnerBuy
//
//  Created by Knight on 2017/3/23.
//  Copyright © 2017年 sanfenqiu. All rights reserved.
//

#import "NSRegularExpression+IBTopicRegex.h"

@implementation NSRegularExpression (IBTopicRegex)

+ (NSRegularExpression *)regexTopic {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regex;
}
@end
