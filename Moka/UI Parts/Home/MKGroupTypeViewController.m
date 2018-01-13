//
//  MKGroupTypeViewController.m
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGroupTypeViewController.h"
#import "MKSetPaidCountViewController.h"
#import "MKCompleteGroupInfoViewController.h"

@interface MKGroupTypeViewController ()

{
    NSInteger selectedType; //【是否付费 0 不  1 要】
}

@property (weak, nonatomic) IBOutlet UIImageView *freeImgView;

@property (weak, nonatomic) IBOutlet UIImageView *piadImgView;

@end

@implementation MKGroupTypeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"选择圈子属性"];
    self.title = @"选择圈子属性";
    
}



- (IBAction)freeButtonClicked:(UIButton *)sender {
    selectedType = 0;
    _freeImgView.layer.borderWidth = 0;
    _freeImgView.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
    _piadImgView.layer.borderWidth = 1;
    _piadImgView.backgroundColor = RGB_COLOR_HEX(0xFFFFFF);
    [self showAlertWithType:0];
    
}
- (IBAction)paidButtonClicked:(UIButton *)sender {
    selectedType = 1;
    _freeImgView.layer.borderWidth = 1;
    _freeImgView.backgroundColor = RGB_COLOR_HEX(0xFFFFFF);
    _piadImgView.layer.borderWidth = 0;
    _piadImgView.backgroundColor = RGB_COLOR_HEX(0xE9EDFE);
    [self showAlertWithType:1];
}

- (void)showAlertWithType:(NSInteger)tp {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请不要创建包含时政、低俗、色情、暴力、引诱等内容的圈子，否则将会被封停圈子和账号。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        if (tp == 0) {
            MKCompleteGroupInfoViewController *vc = [[MKCompleteGroupInfoViewController alloc] init];
            vc.ifPay = selectedType;
            vc.isFromChat = self.isFromChat;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (tp == 1) {
            MKSetPaidCountViewController *paidVC = [[MKSetPaidCountViewController alloc] init];
            paidVC.ifPay = selectedType;
            paidVC.isFromChat = self.isFromChat;
            [self.navigationController pushViewController:paidVC animated:YES];
        }
        
    }];
    [alertController addAction:actionDefault];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



@end
