//
//  MKMyWalletViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKMyWalletViewController.h"
#import "MKRechargeCoinsViewController.h"
#import "MKWithdrawViewController.h"
#import "MKTradingRecordViewController.h"
#import "MKRealNameAuthenViewController.h"
#import "TVRewardsBillViewController.h"
#import "TchatFeedBackViewController.h"
#import "TVRewardsViewController.h"

@interface MKMyWalletViewController ()

{
    NSInteger identityAuthen;// 0 审核中  1 审核成功  2 审核失败  3 未审核
    NSString *_rebates;      // 广告活动是否结束 0：结束 1：进行中
}
//背景视图
@property (strong, nonatomic) IBOutlet UIView *baseView;
//点击区域1
@property (strong, nonatomic) IBOutlet UIButton *toAllBillsBtn;
- (IBAction)ToAllBillsClicked:(UIButton *)sender;
//点击区域2
@property (strong, nonatomic) IBOutlet UIButton *toLockBillsBtn;
- (IBAction)ToLockBillsClicked:(UIButton *)sender;
//点击区域3
@property (strong, nonatomic) IBOutlet UIButton *toRewardBillsBtnI;
- (IBAction)toTVRewardsClicked:(UIButton *)sender;
//点击区域4
@property (strong, nonatomic) IBOutlet UIButton *toRewardBillsBtnII;
- (IBAction)toTVRewardsClickedI:(UIButton *)sender;
//
@property (weak, nonatomic) IBOutlet UILabel *remianCoinLabel;
//锁定的钛值
@property (strong, nonatomic) IBOutlet UILabel *freezonTVLabel;
//累计奖励
@property (strong, nonatomic) IBOutlet UILabel *totalRewardTVLabel;
//最新奖励
@property (strong, nonatomic) IBOutlet UILabel *latestRewardTVLabel;
//提升奖励
@property (strong, nonatomic) IBOutlet UIImageView *addRewardImageView;
@property (strong, nonatomic) IBOutlet UIButton *addRewardBtn;
- (IBAction)addRewardClick:(UIButton *)sender;
@end

@implementation MKMyWalletViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"我的钛值";
    
    [self setbaseSeting];
    [self requestMyWalletMoney];
    [self requestAuthenStatus];
    
    //
    if ([_rebates isEqualToString:@"0"]) {
        
        self.addRewardImageView.hidden = YES;
        self.addRewardBtn.hidden = YES;
    }else{
        self.addRewardImageView.hidden = NO;
        self.addRewardBtn.hidden = NO;
    }
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMyWalletMoney) name:@"RefreshWallet" object:nil];
    //
    if ([self.judgeStr isEqualToString:@"comeFromLockSuc"]) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_back"] style:UIBarButtonItemStylePlain target:self action:@selector(lefiItemClick)];
    }
    //
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

#pragma mark -- 页面跳转
-(void)lefiItemClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)onClickedOKbtn{
    
    MKTradingRecordViewController *vc = [[MKTradingRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [self requestMyWalletMoney];
    self.remianCoinLabel.textColor = RGBCOLOR(120, 148, 249);
    self.freezonTVLabel.textColor = RGBCOLOR(42, 42, 42);
    self.totalRewardTVLabel.textColor = RGBCOLOR(42, 42, 42);
    self.latestRewardTVLabel.textColor = RGBCOLOR(42, 42, 42);
    
    
}



#pragma mark -- 手势
-(void)setbaseSeting{
    
    //设置背景视图
    self.baseView.layer.cornerRadius = 5.0f;
    self.baseView.layer.shadowRadius = 5.0;
    self.baseView.clipsToBounds = NO;
    self.baseView.layer.shadowColor = RGB_COLOR_ALPHA(0, 0, 0, 0.2).CGColor;
    self.baseView.layer.shadowOffset = CGSizeMake(0, 2);
    self.baseView.layer.shadowOpacity = 1;
    //
    self.remianCoinLabel.adjustsFontSizeToFitWidth = YES;
    self.freezonTVLabel.adjustsFontSizeToFitWidth = YES;
    self.totalRewardTVLabel.adjustsFontSizeToFitWidth = YES;
    self.latestRewardTVLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (IBAction)rechargeButtonClicked:(id)sender {
//    [MKUtilHUD showAutoHiddenTextHUD:@"钱包维护中" withSecond:2 inView:self.view];
//    
//    return;
    
    //动态充值页面
    MKRechargeCoinsViewController *vc = [[MKRechargeCoinsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
  
//    if (identityAuthen == 0) {
//        [self showAuthorizionOngoingAlert];
//    } else if (identityAuthen == 1) {
//        MKRechargeCoinsViewController *vc = [[MKRechargeCoinsViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        [self showAuthorizionAlert];
//    }
    
    
}

- (IBAction)withdrawButtonClicked:(id)sender {
    
    if (identityAuthen == 0) {
        [self showAuthorizionOngoingAlert];
    } else if (identityAuthen == 1) {
        MKWithdrawViewController *vc = [[MKWithdrawViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self showAuthorizionAlert];
    }
}

#pragma mark - http :查询个人金额

- (void)requestMyWalletMoney {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_myWalletMoney] params:nil success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"查询个人金额 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            _rebates = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"rebates"]];
            //我的钛值
            strongSelf.remianCoinLabel.text = [NSString stringWithFormat:@"%.3f",([json[@"dataObj"][@"balance"] integerValue] / 1000.0 +[json[@"dataObj"][@"lockSum"] integerValue] / 1000.0)];
            //锁定总额
            strongSelf.freezonTVLabel.text = [NSString stringWithFormat:@"%.3f",[json[@"dataObj"][@"lockSum"] integerValue] / 1000.0];
            //累计奖励
            strongSelf.totalRewardTVLabel.text = [NSString stringWithFormat:@"%.3f",[json[@"dataObj"][@"feedbackSum"] integerValue] / 1000.0];
            //最新奖励
            strongSelf.latestRewardTVLabel.text = [NSString stringWithFormat:@"%.3f",[json[@"dataObj"][@"newTvFeedback"][@"dayinterest"] integerValue] / 1000.0];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


#pragma mark - HTTP 查询是否认证
- (void)requestAuthenStatus {
    NSDictionary *param = @{};
    [MKUtilHUD showHUD:self.view];
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_ifAuthen] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        NSLog(@"是否认证 %@",json);
        if (status == 200) {

            identityAuthen = [json[@"dataObj"][@"identity"] integerValue];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
        
    }];
}

- (void)showAuthorizionAlert {
    //弹窗提醒
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了您的交易安全，请实名认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        MKRealNameAuthenViewController *vc = [[MKRealNameAuthenViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionDefault];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAuthorizionOngoingAlert {
    //弹窗提醒
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的身份正在审核中, 敬请等待..." preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:actionDefault];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- 提升奖励

- (IBAction)addRewardClick:(UIButton *)sender {
    
    TchatFeedBackViewController * vc = [[TchatFeedBackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 页面跳转
- (IBAction)ToAllBillsClicked:(UIButton *)sender {
    
    self.remianCoinLabel.textColor = RGBCOLOR(42, 42, 42);
    MKTradingRecordViewController *vc = [[MKTradingRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ToLockBillsClicked:(UIButton *)sender {
    
    self.freezonTVLabel.textColor = RGBCOLOR(120, 148, 249);
    TVRewardsBillViewController * vc = [[TVRewardsBillViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toTVRewardsClicked:(UIButton *)sender {
    
    self.totalRewardTVLabel.textColor = RGBCOLOR(120, 148, 249);
    TVRewardsViewController * vc = [[TVRewardsViewController alloc]init];
    vc.over = _rebates;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toTVRewardsClickedI:(UIButton *)sender {
    
    self.latestRewardTVLabel.textColor = RGBCOLOR(120, 148, 249);
    TVRewardsViewController * vc = [[TVRewardsViewController alloc]init];
    vc.over = _rebates;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
