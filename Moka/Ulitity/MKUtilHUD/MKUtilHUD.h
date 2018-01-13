//
//  MKUtilHUD.h
//  Moka
//
//  Created by Knight on 2017/7/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define MB_HUD_AUTO_HIDDEN_SECOND (2)

@interface MKUtilHUD : NSObject

#pragma mark - MB Progress HUD static
+ (MBProgressHUD *)showMoreHUD:(NSString *)text inView:(UIView *)view;
+ (MBProgressHUD *)getHUD:(UIView *)view;
+ (MBProgressHUD *)showHUD:(UIView *)view;
+ (MBProgressHUD *)showHUD:(NSString *)text inView:(UIView *)view;
+ (MBProgressHUD *)showHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;
+ (MBProgressHUD *)showHUD:(NSString *)text withTask:(SEL)task onTarget:(id)target withObject:(id)object inView:(UIView *)view;
+ (void)showshowAutoHiddenTextHUD:(NSString *)text withSecond:(NSTimeInterval)second inView:(UIView *)view;
+ (void)hiddenHUD:(UIView *)view;

#pragma mark MB Progress HUD static auto hidden
+ (void)showAutoHiddenTextHUD:(NSString *)text inView:(UIView *)view;
+ (void)showAutoHiddenTextHUD:(NSString *)text withSecond:(NSTimeInterval)second inView:(UIView *)view;
+ (void)showAutoHiddenTextHUD:(NSString *)text withSecond:(NSTimeInterval)second inView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;


@end
