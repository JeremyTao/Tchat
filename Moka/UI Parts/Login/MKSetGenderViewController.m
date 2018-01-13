//
//  MKSetGenderViewController.m
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSetGenderViewController.h"
#import "MKSetPortraitViewController.h"
#import "MKTabBarViewController.h"


@interface MKSetGenderViewController ()

{
    NSInteger myGender;
}


@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;



@end

@implementation MKSetGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
    self.title = @"您的性别";
    [self hideBackButton];
    
    [self.navigationItem setHidesBackButton:YES];
    self.fd_interactivePopDisabled = YES;
}




- (IBAction)femaleSelect:(UIButton *)sender {
    myGender = 1;
    [_femaleButton setImage:IMAGE(@"girl_choose") forState:UIControlStateNormal];
    [_femaleButton setImage:IMAGE(@"girl_choose") forState:UIControlStateHighlighted];
    [_maleButton setImage:IMAGE(@"boy") forState:UIControlStateNormal];
    [_maleButton setImage:IMAGE(@"boy") forState:UIControlStateHighlighted];
    [self showAlert];
}

- (IBAction)maleSelect:(UIButton *)sender {
    myGender = 2;
    [_femaleButton setImage:IMAGE(@"girl") forState:UIControlStateNormal];
    [_femaleButton setImage:IMAGE(@"girl") forState:UIControlStateHighlighted];
    [_maleButton setImage:IMAGE(@"boy_choose") forState:UIControlStateNormal];
    [_maleButton setImage:IMAGE(@"boy_choose") forState:UIControlStateHighlighted];
    [self showAlert];
}


- (void)showAlert {
    //弹窗提醒
    NSString *title;
    if (myGender == 1) {
        title = @"是否选择女性？";
    } else if (myGender == 2) {
        title = @"是否选择男性？";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"确定后不可更改性别！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self requestSetGender];
    }];
    [alertController addAction:actionDefault];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark - http : 性别设置

- (void)requestSetGender {
    NSDictionary *param = @{@"sex":@(myGender)};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_updateUser] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSLog(@"性别设置 %@",json);
        if (status == 200) {
            //判断是否存在头像
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
                
                MKSetPortraitViewController *vc = [[MKSetPortraitViewController alloc] init];
                vc.addInfo = self.addInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if ([[NSUserDefaults standardUserDefaults] stringForKey:@"userInfo.userImageStr"].length == 0) {
                    
                    MKSetPortraitViewController *vc = [[MKSetPortraitViewController alloc] init];
                    vc.addInfo = self.addInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    //2. 跳转到下一步
                    MKTabBarViewController *tabBarVC = [[MKTabBarViewController alloc] init];
                    tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:tabBarVC animated:YES completion:nil];
                }
            }
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);

    }];
}


@end
