//
//  IBCommShare.h
//  InnerBuy
//
//  Created by 郑克 on 2017/3/2.
//  Copyright © 2017年 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WXApi.h"

@interface IBCommShare : NSObject
+ (BOOL)isWXAppInstalled;

//+(BOOL)isQQAppInstalled;
//+(void)shareToQQMoments:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl;
//
//+(void)shareToQQFriends:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl;

+ (void)shareToWeichatMoments:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl;
+ (void)shareToWeichatFriends:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareThumbImg:(NSString *)shareThumbImg shareUrl:(NSString *)shareUrl;

@end
