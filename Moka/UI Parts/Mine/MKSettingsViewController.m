//
//  MKSettingsViewController.m
//  Moka
//
//  Created by  moka on 2017/7/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSettingsViewController.h"
#import "MKLoginViewController.h"
#import "MKFeedbackViewController.h"
#import "MKNoticeSettingViewController.h"

@interface MKSettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cachesLabel;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
@end

@implementation MKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setNavigationTitle:@"设置"];
    [self loadMemerySize];
}

// 加载内存大小
- (void)loadMemerySize{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * tempMemeryStr = [self cacheStringWithSDCache:[[SDImageCache sharedImageCache] getSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.cachesLabel.text = tempMemeryStr;
        });
        
    });
}

- (NSString *)cacheStringWithSDCache:(NSInteger)cacheSize{
    
    if (cacheSize == 0) {
        return @"0KB";
    }
    if (cacheSize > 0 && cacheSize < 1024) {
        return [NSString stringWithFormat:@"%d B",(int)cacheSize];
    }else if (cacheSize < 1024 * 1024){
        return [NSString stringWithFormat:@"%.2f KB",cacheSize / 1024.0];
    }else if (cacheSize < 1024 * 1024 * 1024){
        return [NSString stringWithFormat:@"%.2f MB",cacheSize / (1024.0 * 1024.0)];
    }else{
        return [NSString stringWithFormat:@"%.2f G",cacheSize / (1024.0 * 1024.0 * 1024.0)];
    }
    
    return nil;
}



- (IBAction)noticeButtonClicked:(id)sender {
    MKNoticeSettingViewController *vc = [[MKNoticeSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)myLocationSwitchEvent:(UISwitch *)sender {
}


- (IBAction)feedbackButtonClicked:(UIButton *)sender {
    MKFeedbackViewController *vc = [[MKFeedbackViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clearCachesButtonClicked:(UIButton *)sender {
    //弹窗提醒
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否清除缓存?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [MKUtilHUD showHUD:self.view];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            [[SDImageCache sharedImageCache] clearDisk];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [MKUtilHUD hiddenHUD:self.view];
                self.cachesLabel.text = @"0KB";
            });
        });
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionDefault];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (IBAction)logOutButtonClicked:(UIButton *)sender {
    
    //2.弹出登录页面
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        //1.清除token
        [[A0SimpleKeychain keychain] deleteEntryForKey:apiTokenKey];
        //3.退出融云登陆
        [[RCIMClient sharedRCIMClient] logout];
        
        [[A0SimpleKeychain keychain] deleteEntryForKey:apiRongCloudToken];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.portraitUri"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userInfo.userId"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CurrentUserPhone"];
        
        //清除未读消息
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        
        MKLoginViewController *lovc = [[MKLoginViewController alloc] init];
        MKNavigationController *navc  = [[MKNavigationController alloc]initWithRootViewController:lovc];
        [self presentViewController:navc animated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
    [alertController addAction:actionDefault];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
