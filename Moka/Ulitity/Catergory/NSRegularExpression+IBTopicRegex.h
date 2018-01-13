//
//  NSRegularExpression+IBTopicRegex.h
//  InnerBuy
//
//  Created by Knight on 2017/3/23.
//  Copyright © 2017年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (IBTopicRegex)

/// 话题正则 例如 #夏天帅不帅#
+ (NSRegularExpression *)regexTopic;

@end
