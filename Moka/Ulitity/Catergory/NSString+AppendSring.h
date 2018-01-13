//
//  NSString+AppendSring.h
//  InnerBuy
//
//  Created by Knight on 13/10/2016.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppendStrings(firstStr,...) [NSString JoinedWithSubStrings:firstStr,__VA_ARGS__,nil]

@interface NSString (AppendSring)


+ (NSString *)JoinedWithSubStrings:(NSString *)firstStr,...NS_REQUIRES_NIL_TERMINATION;

+(NSString *)lowercaseSpellingWithChineseCharacters:(NSString *)chinese;

@end
