//
//  NSString+productString.h
//  InnerBuy
//
//  Created by 郑克 on 16/5/17.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (productString)
+(NSArray *)getMyString:(NSString *)allString;
+(NSString *)getIPAddress:(BOOL)preferIPv4;
+(NSArray *)getMyStringTwo:(NSString *)allString;
@end
