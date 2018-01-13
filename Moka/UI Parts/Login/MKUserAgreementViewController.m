//
//  MKUserAgreementViewController.m
//  Moka
//
//  Created by Knight on 2017/8/30.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUserAgreementViewController.h"

@interface MKUserAgreementViewController ()

@end

@implementation MKUserAgreementViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"用户协议&服务条款"];
    self.title = @"用户协议&服务条款";
}



@end
