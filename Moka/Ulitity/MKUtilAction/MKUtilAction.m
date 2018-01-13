//
//  MKUtilAction.m
//  Moka
//
//  Created by Knight on 2017/7/25.
//  Copyright © 2017年 moka. All rights reserved.
//





#define usAPIFailTitle      NSLocalizedString(@"APIFailTitle", nil)
#define HttpCodeForbidden       401
#define MainStoryboard          [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define loginViewIdentifier     @"loginView"

#import "MKUtilAction.h"
#import "MKLoginViewController.h"
#import "MKNavigationController.h"


@implementation MKUtilAction

+ (void)doApiFail:(NSError *)error
{
    NSLog(@"%@",error);
    MBProgressHUD *hud = [MKUtilHUD getHUD:nil];
    
    hud.mode = MBProgressHUDModeText;
    
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    
    hud.labelText = @"温馨提示！";
    hud.detailsLabelText =  [error localizedDescription];
    hud.removeFromSuperViewOnHide = YES;
    
    [hud show:YES];
    [hud hide:YES afterDelay:ACTION_API_FAIL_TIP_SECOND];
}


+ (void)alert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

+ (void)warnAlert: (NSString *)message
{
    [self alert:@"警告" message:message];
}

+ (void)remindAlert: (NSString *)message
{
    [self alert:@"提示" message:message];
}

+ (void)doTokenError:(UIViewController *)controller
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MKNavigationController *navc = [[MKNavigationController alloc]initWithRootViewController:[[MKLoginViewController alloc] init]];
        
        [controller presentViewController:navc animated:YES completion:^{}];
    });
    
    
//    MBProgressHUD *HUD = [MKUtilHUD getHUD:nil];
//    
//    [HUD setLabelText:@"您的账号已在其他设备登陆!"];
//    [HUD show:YES];
    
//    HUD.completionBlock = ^{
//        
//    };
//    
//    [HUD hide:YES afterDelay:2];
}

+ (void)doApiTokenFailWithStatusCode:(NSInteger)status inController:(UIViewController *)controller {
   
    if (status == 400) {
        //清除token
        [[A0SimpleKeychain keychain] deleteEntryForKey:apiTokenKey];
        [[A0SimpleKeychain keychain] deleteEntryForKey:apiRongCloudToken];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.portraitUri"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.userId"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CurrentUserPhone"];
        
        //清除未读消息
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        //3.退出融云登陆
        [[RCIMClient sharedRCIMClient] logout];
        //token失效
        [self doTokenError:controller];
        
        
        
    }
}

+ (void)doApiFailWithToken:(NSHTTPURLResponse *)response ctrl:(UIViewController *)controller with:(NSError *)error
{
    if(response.statusCode == HttpCodeForbidden)
    {
        [self doTokenError:controller];
        //清空token
        //[[CDCoreDateSql sharedCoreDateSql] clearToken];
    }else if(response.statusCode == 403)
    {
        [MKUtilHUD showMoreHUD:@"暂无权限操作！" inView:controller.view];
    }
    else if(response.statusCode == 404)
    {
        [MKUtilHUD showMoreHUD:@"暂没找到数据！" inView:controller.view];
    }
    else if(response.statusCode == 412)
    {
        [MKUtilHUD showHUD:@"版本过低，请更新" inView:controller.view];
    }else if(response.statusCode == 406)
    {
//        CBNavigationController *navc = [[CBNavigationController alloc]initWithRootViewController:[[CBCommCreatClubViewController alloc] init]];
//        [controller presentViewController:navc animated:YES completion:^{
//            
//        }];
    }
    else
    {
        [self doApiFail:error];
    }
}

+ (void)doCSCall:(UIViewController *)ctrl
{
    NSString *telNumber = @"4008513365";
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPod touch"]||[deviceType isEqualToString:@"iPad"]||[deviceType isEqualToString:@"iPhone Simulator"])
    {
        [MKUtilHUD showAutoHiddenTextHUD:@"您的设备不支持打电话" withSecond:2.f inView:nil completionBlock:nil];
    }
    else
    {
        [MKUtilAction dialPhoneNumber:telNumber controller:ctrl];
    }
}

+ (void) dialPhoneNumber:(NSString *)aPhoneNumber controller:(UIViewController *)ctrl
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",aPhoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [ctrl.view addSubview:callWebview];
}



@end
