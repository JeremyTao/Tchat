//
//  MKUtilAction.h
//  Moka
//
//  Created by Knight on 2017/7/25.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatUtil.h"

#define ACTION_API_FAIL_TIP_SECOND (2)


@interface MKUtilAction : NSObject

+ (void)doApiFail:(NSError *)error;
+ (void)doTokenError:(UIViewController *)controller;

+ (void)doApiFailWithToken:(NSHTTPURLResponse *)response ctrl:(UIViewController *)controller with:(NSError *)error;
+ (void)warnAlert: (NSString *)message;
+ (void)remindAlert: (NSString *)message;
+ (void)alert:(NSString *)title message:(NSString *)message;

+ (void)doCSCall:(UIViewController *)ctrl;

+ (void)doApiTokenFailWithStatusCode:(NSInteger)status inController:(UIViewController *)controller;
@end
