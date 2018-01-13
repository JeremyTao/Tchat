//
//  TVLockSuccessViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "TVLockSuccessViewController.h"
#import "MKMyWalletViewController.h"

@interface TVLockSuccessViewController ()
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;

//返回按钮
@property (strong, nonatomic) IBOutlet UIButton *TVfeedBackBtn;
- (IBAction)TVfeedBackClick:(UIButton *)sender;

@end

@implementation TVLockSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"锁定成功";
    
    _TVfeedBackBtn.layer.cornerRadius = 25.0f;
    //提示
    self.noticeLabel.text = [NSString stringWithFormat:@"%@开始发放奖励，连续发放180天后停止发放并解锁钛值。",self.startTimeStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)TVfeedBackClick:(UIButton *)sender {
    
    if ([self.Suc isEqualToString:@"0"]) {
        
        MKMyWalletViewController * vc = [[MKMyWalletViewController alloc]init];
        vc.judgeStr = @"comeFromLockSuc";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        for (MKMyWalletViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass: [MKMyWalletViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }

    }
}
@end
