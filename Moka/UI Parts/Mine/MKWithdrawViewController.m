//
//  MKWithdrawViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKWithdrawViewController.h"
#import "QRCodeVC.h"
#import "MKInputAdressViewController.h"
@interface MKWithdrawViewController ()

@end

@implementation MKWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"转出钛值";
    
}


- (IBAction)scanCodeButtonClicked:(id)sender {
    QRCodeVC *scanVC = [[QRCodeVC alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (IBAction)inputAdressButtonClicked:(id)sender {
    MKInputAdressViewController *vc = [[MKInputAdressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
