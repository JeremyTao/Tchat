//
//  MKSettingPasswordViewController.m
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSettingPasswordViewController.h"
#import "MKSetPaymentPasswordViewController.h"
#import "MKSetLoginPasswordViewController.h"

@interface MKSettingPasswordViewController ()

@end

@implementation MKSettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"密码设置"];
    self.title = @"密码设置";
}

- (IBAction)setPaymentPasswordButtonClicked:(id)sender {
    MKSetPaymentPasswordViewController *vc = [[MKSetPaymentPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)setLoginPasswordButtonClicked:(id)sender {
    MKSetLoginPasswordViewController *vc = [[MKSetLoginPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
