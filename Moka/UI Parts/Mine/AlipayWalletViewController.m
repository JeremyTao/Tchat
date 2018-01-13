//
//  AlipayWalletViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "AlipayWalletViewController.h"
#import "UNbundleAlertView.h"
#import "alipayAllBillsViewController.h"
#import "AlipayChargeViewController.h"
#import "alipayWithdrawViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MKRealNameAuthenViewController.h"

@interface AlipayWalletViewController ()
{
    BOOL _isBundle;
    NSString *_authInfo;
    NSString *_balance;
    NSInteger identityAuthen;// 0 审核中  1 审核成功  2 审核失败  3 未审核
}
@property (strong, nonatomic) IBOutlet UIView *apiBaseView;
//我的零钱
@property (strong, nonatomic) IBOutlet UILabel *api_myWalletSumLabel;
//支付宝账号
@property (strong, nonatomic) IBOutlet UILabel *UserAliPayAccountLabel;
//解绑
@property (strong, nonatomic) IBOutlet UIButton *unBundleBtn;
- (IBAction)unbundlClicked:(UIButton *)sender;
//绑定支付宝
@property (strong, nonatomic) IBOutlet UIButton *bundleAlipayBtn;
- (IBAction)bundleAlipayClicked:(UIButton *)sender;
//充值
- (IBAction)AlipayrechargeClicked:(UIButton *)sender;
//提现
- (IBAction)alipayWithdrawClicked:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeight;

@end

@implementation AlipayWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的零钱";
    _isBundle = NO;
    [self checkUserWeatherBundle];
    [self requestAuthenStatus];
    
    self.bundleAlipayBtn.layer.cornerRadius = 25.0f;
    //明细
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(chargeBills)];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bundle:) name:@"MyWallet"object:nil];
    
    
}

- (void)bundle:(NSNotification *)noti{
    
    //绑定账号
    [self requestBundle:noti.userInfo[@"authCode"]];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyWallet" object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self checkMyBalance];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark -- 明细
-(void)chargeBills{
    
    alipayAllBillsViewController * vc = [[alipayAllBillsViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


//解绑
- (IBAction)unbundlClicked:(UIButton *)sender {
    
    [self setUnbundleAlipayNotice];
}
//绑定
- (IBAction)bundleAlipayClicked:(UIButton *)sender {
    
    //授权
    [[AlipaySDK defaultService] auth_V2WithInfo:_authInfo fromScheme:ALIPAY_SCHEME callback:^(NSDictionary *resultDic) {
        
        NSLog(@"支付宝授权结果 %@",resultDic);
    }];

}          
//充值
- (IBAction)AlipayrechargeClicked:(UIButton *)sender {
    
    AlipayChargeViewController * vc = [[AlipayChargeViewController alloc]init];
    vc.myBalance = _balance;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//提现
- (IBAction)alipayWithdrawClicked:(UIButton *)sender {
    
    if (_isBundle) {
        
        if (identityAuthen == 0) {
            [self showAuthorizionOngoingAlert];
        } else if (identityAuthen == 1) {
            
            alipayWithdrawViewController * vc = [[alipayWithdrawViewController alloc]init];
            vc.nickName = self.UserAliPayAccountLabel.text;
            vc.alipayBalance = self.api_myWalletSumLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showAuthorizionAlert];
        }
    }else{
        [MKUtilHUD showHUD:@"请先绑定支付宝" inView:nil];
    }

}

#pragma mark -- 身份证正在审核中
- (void)showAuthorizionOngoingAlert {
    //弹窗提醒
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的身份正在审核中, 敬请等待..." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:actionDefault];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- 去实名认证
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


#pragma mark -- 弹窗
//解绑
-(void)setUnbundleAlipayNotice{
    
    UNbundleAlertView *xlAlertView = [[UNbundleAlertView alloc] initNnbundleAlertView:@"你确定解除支付宝绑定吗"];
    xlAlertView.resultIndex = ^(NSInteger index){
        //回调---处理一系列动作
        
        [self cancleBundleAlipay];
        
    };
    [xlAlertView showAlertView];
    
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

#pragma mark -- 绑定支付宝
-(void)requestBundle:(NSString *)code{
    
    NSDictionary * param = @{@"accountType":@"0",
                             @"auth_code":code
                             };
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_alipayBundleAccount] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"绑定信息 %@",json);
        if (status == 200) {
            
            if ([json[@"dataObj"][@"account"] isEqualToString:@""]) {
                strongSelf.UserAliPayAccountLabel.text = [NSString stringWithFormat:@"支付宝账号:%@",json[@"dataObj"][@"nickName"]];
            }else
            {
                strongSelf.UserAliPayAccountLabel.text = [NSString stringWithFormat:@"支付宝账号:%@",json[@"dataObj"][@"account"]];
            }
            _isBundle = YES;
            [self loadBaseViews];
        }else{
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        
        NSLog(@"%@",error);
    }];
    
}

#pragma mark -- 解绑
-(void)cancleBundleAlipay{
    
    NSDictionary * param = @{@"accountType":@"0"};
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_alipayUnBundleAcc] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"解绑信息 %@",json);
        
        if (status == 200) {
            
             [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
            _isBundle = NO;
            [self loadBaseViews];
        }else{
            
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
        
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];

        NSLog(@"%@",error);
    }];
}

#pragma mark -- 检查是否绑定
-(void)checkUserWeatherBundle{
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_alipayMyMoney] params:nil success:^(id json) {
        STRONG_SELF;
        //[MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"我的零钱 %@",json);
        
        if (status == 200) {
            //我的零钱
            _balance = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"money"]];
            strongSelf.api_myWalletSumLabel.text = [NSString stringWithFormat:@"%.2f",[_balance doubleValue]];
            //认证信息
            _authInfo = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"authInfo"]];

            //没有绑定支付宝
            if ([json[@"dataObj"][@"state"] integerValue] == 0) {
                _isBundle = NO;
                
            }else{
                _isBundle = YES;
                if ([json[@"dataObj"][@"account"] isEqualToString:@""]) {
                    strongSelf.UserAliPayAccountLabel.text = [NSString stringWithFormat:@"支付宝账号:%@",json[@"dataObj"][@"nickName"]];
                }else
                {
                    strongSelf.UserAliPayAccountLabel.text = [NSString stringWithFormat:@"支付宝账号:%@",json[@"dataObj"][@"account"]];
                }
            }
            
            [self loadBaseViews];
        }else{
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
        
    }];
}
-(void)loadBaseViews{
    
    if (_isBundle) {
        self.bundleAlipayBtn.hidden = YES;
        self.UserAliPayAccountLabel.hidden = NO;
        self.unBundleBtn.hidden = NO;
        self.baseViewHeight.constant = 160.0f;
    }else{
        self.bundleAlipayBtn.hidden = NO;
        self.UserAliPayAccountLabel.hidden = YES;
        self.unBundleBtn.hidden = YES;
        self.baseViewHeight.constant = 201.0f;
    }
}

#pragma mark -- 查询余额

-(void)checkMyBalance{
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_myBalance] params:nil success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"查询余额 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            strongSelf.api_myWalletSumLabel.text = [NSString stringWithFormat:@"%.2f",[json[@"dataObj"][@"rmbBalance"] doubleValue]];
           
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



@end
