//
//  withDrawSucViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/18.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "withDrawSucViewController.h"
#import "AlipayWalletViewController.h"


@interface withDrawSucViewController ()
//发起申请
@property (strong, nonatomic) IBOutlet UIView *applicationView;
//
@property (strong, nonatomic) IBOutlet UIView *getSucView;
//到账成功
@property (strong, nonatomic) IBOutlet UIView *applicationSucView;
//提现金额
@property (strong, nonatomic) IBOutlet UILabel *withDrawSumLabel;
//手续费
@property (strong, nonatomic) IBOutlet UILabel *feeLabel;
//支付宝账号
@property (strong, nonatomic) IBOutlet UILabel *alipayAccountLabel;
//完成
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureClicked:(UIButton *)sender;


@end

@implementation withDrawSucViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"提现至支付宝";
    //
    [self loadBaseViews];
    
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

#pragma mark -- 基本设置
-(void)loadBaseViews{
    self.applicationView.layer.cornerRadius = 7.0f;
    self.applicationSucView.layer.cornerRadius = 7.0f;
    self.sureBtn.layer.cornerRadius = 25.0f;
    //状态
    if ([self.status isEqualToString:@"0"]) {
        //审核中
        self.getSucView.backgroundColor = RGBCOLOR(204, 204, 204);
        self.applicationSucView.backgroundColor = RGBCOLOR(204, 204, 204);
    }else{
        
        self.getSucView.backgroundColor = RGBCOLOR(120, 148, 249);
        self.applicationSucView.backgroundColor = RGBCOLOR(120, 148, 249);
    }
    //提现金额
    self.withDrawSumLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.money doubleValue]];
    //手续费
    self.feeLabel.text = [NSString stringWithFormat:@"¥%@",self.fee];
    //到账账号
    self.alipayAccountLabel.text = self.account;
}


- (IBAction)sureClicked:(UIButton *)sender {
    
    for (AlipayWalletViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass: [AlipayWalletViewController class]]) {
            
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
@end
