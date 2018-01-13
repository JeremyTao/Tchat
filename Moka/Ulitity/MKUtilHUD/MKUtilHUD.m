//
//  MKUtilHUD.m
//  Moka
//
//  Created by Knight on 2017/7/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUtilHUD.h"

@implementation MKUtilHUD

#pragma mark - MB Progress HUD
+ (MBProgressHUD *)getHUD:(UIView *)view
{
    MBProgressHUD *HUD = nil;
    
    if(view == nil)
    {
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        HUD.opacity = 0.6;
        //        HUD.dimBackground = YES;
        HUD.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.70];
        HUD.removeFromSuperViewOnHide = YES;
        
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
    else
    {
        HUD = [[MBProgressHUD alloc] initWithView:view];
        HUD.opacity = 0.6;
        //        HUD.dimBackground = YES;
        HUD.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.70];
        HUD.removeFromSuperViewOnHide = YES;
        
        [view addSubview:HUD];
    }
    
    return HUD;
}

+ (MBProgressHUD *)showHUD:(UIView *)view
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    MBProgressHUD *hud = [self getHUD:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    return hud;
}

+ (MBProgressHUD *)showHUD:(NSString *)text inView:(UIView *)view
{
    return [self showwHUD:text detailText:@"" inView:view];
}
+ (MBProgressHUD *)showwHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view
{
    MBProgressHUD *hud = [self getHUD:view];
    hud.mode = MBProgressHUDModeText;
    hud.minShowTime = 2.0;
    hud.labelText = text;
    hud.detailsLabelText = detailText;
    [hud show:YES];
    [hud hide:YES afterDelay:0.6];
    return hud;
}
+ (MBProgressHUD *)showMoreHUD:(NSString *)text inView:(UIView *)view{
    MBProgressHUD *hud = [self getHUD:view];
    hud.mode = MBProgressHUDModeText;
    hud.minShowTime = 2.0;
    hud.detailsLabelText = text;
  
    [hud show:YES];
    [hud hide:YES afterDelay:0.6];
    
    return hud;
}
+ (MBProgressHUD *)showHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view
{
    MBProgressHUD *hud = [self getHUD:view];
    hud.mode = MBProgressHUDModeText;
   
    hud.labelText = text;
    hud.detailsLabelText = detailText;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];

    [hud show:YES];
    [hud hide:YES afterDelay:3.0];
    return hud;
}

+ (MBProgressHUD *)showHUD:(NSString *)text withTask:(SEL)task onTarget:(id)target withObject:(id)object inView:(UIView *)view
{
    MBProgressHUD *hud = [MKUtilHUD showMoreHUD:text inView:view];
    [hud showWhileExecuting :task onTarget:target withObject:object animated:YES];
    return hud;
}

+ (void)hiddenHUD:(UIView *)view
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(view == nil)
    {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow  animated:YES];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }
}

#pragma mark MB Progress HUD static auto hidden
+ (void)showAutoHiddenTextHUD:(NSString *)text inView:(UIView *)view
{
    [self showAutoHiddenTextHUD:text withSecond:MB_HUD_AUTO_HIDDEN_SECOND inView:view];
}
+ (void)showshowAutoHiddenTextHUD:(NSString *)text withSecond:(NSTimeInterval)second inView:(UIView *)view{
    [self showshowAutoHiddenTextHUD:text withSecond:second inView:view completionBlock:nil];
    
}
+ (void)showshowAutoHiddenTextHUD:(NSString *)text withSecond:(NSTimeInterval)second inView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock
{
    MBProgressHUD *hud = [self getHUD:view];
    hud.mode = MBProgressHUDModeText;
    hud.completionBlock = completionBlock;
    hud.minShowTime = second;
    hud.labelText = text;
    
    [hud show:YES];
    
    [hud hide:YES afterDelay:second];
}
+ (void)showAutoHiddenTextHUD:(NSString *)text withSecond:(NSTimeInterval)second inView:(UIView *)view
{
    [self showAutoHiddenTextHUD:text withSecond:second inView:view completionBlock:nil];
}

+ (void)showAutoHiddenTextHUD:(NSString *)text withSecond:(NSTimeInterval)second inView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock
{
    MBProgressHUD *hud = [self getHUD:view];
    hud.mode = MBProgressHUDModeText;
    hud.completionBlock = completionBlock;
    hud.labelText = text;
    
    [hud show:YES];
    
    [hud hide:YES afterDelay:second];
}

@end
