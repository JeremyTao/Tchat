//
//  UserDefault.m
//  Moka
//
//  Created by btc123 on 2017/12/25.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault



//保存一键买卖币种
+(void)saveCoins:(NSString *)coins
{
    [[NSUserDefaults standardUserDefaults] setObject:coins forKey:@"Coins"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//取一键买卖币种
+(NSString *)loadCoins
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Coins"];
}
@end
