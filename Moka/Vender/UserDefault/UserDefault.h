//
//  UserDefault.h
//  Moka
//
//  Created by btc123 on 2017/12/25.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject

//保存一键买卖币种
+(void)saveCoins:(NSString *)coins;
+(NSString *)loadCoins;
@end
