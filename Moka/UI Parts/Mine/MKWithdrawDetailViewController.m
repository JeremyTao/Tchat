//
//  MKWithdrawDetailViewController.m
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKWithdrawDetailViewController.h"
#import "MKJoinGroupPopView.h"
#import "RCDCustomerServiceViewController.h"
#import "upLoadImageManager.h"
#import "MKSecurity.h"

@interface MKWithdrawDetailViewController ()

{
    NSString *passwordInput;
}



@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *withdrawTextField;
@property (strong, nonatomic) IBOutlet UITextField *MemoTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (strong, nonatomic) MKJoinGroupPopView *paymentView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *popSuccesView;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@end

@implementation MKWithdrawDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"付款"];
    self.title = @"付款";
    _adressLabel.text = self.withdrawURL;
    [_withdrawTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    WEAK_SELF;
    self.paymentView = [MKJoinGroupPopView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        NSLog(@"text = %@",text);
        passwordInput = text;
        [strongSelf requestPayment];
        [_paymentView hide];
        [strongSelf.view endEditing:YES];
    }];
    
    [self checkNetWork];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(kefuClickeds:)];
}


-(void)kefuClickeds:(UIBarButtonItem *)kefu{
    
    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = RongCloudKeFuServer;
    chatService.title = @"客服";
    
    RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
    //ID
    csInfo.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userId"];
    //nikeName
    csInfo.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    //头像
    csInfo.portraitUrl = [upLoadImageManager judgeThePathForImages:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userImageStr"]];
    //电话
    csInfo.mobileNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.phone"];
    
    chatService.csInfo = csInfo;
    
    [self.navigationController pushViewController :chatService animated:YES];
    
}

-(void)checkNetWork {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] checkNetWorkStatusSuccess:^(id str) {
        STRONG_SELF;
        if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
            //有网络
            [strongSelf hiddenNonetWork];
            [strongSelf requestMyWalletMoney];
            
        }else{
            //无网络
            [strongSelf showNonetWork];
        }
        
    }];
    
}

- (void)textFieldChanged:(UITextField *)textField {
    [self checkInfoComplete];
}

- (void)checkInfoComplete {
    if (_withdrawTextField.text.length > 0) {
        _nextStepButton.backgroundColor = commonBlueColor;
        _nextStepButton.enabled = YES;
        [MKTool addShadowOnView:_nextStepButton];
    } else {
        _nextStepButton.backgroundColor = buttonDisableColor;
        _nextStepButton.enabled = NO;
        [MKTool removeShadowOnView:_nextStepButton];
    }
}

#pragma mark - HTTP 提现查询





#pragma mark - http :查询个人金额

- (void)requestMyWalletMoney {
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myBalance] params:nil success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"查询个人金额 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        //
        if (status == 200) {
            
            strongSelf.moneyLabel.text = [NSString stringWithFormat:@"%@ TV",[NSString removeFloatAllZero:[json[@"dataObj"][@"tvBalance"] integerValue] / 1000.0]];
            
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


#pragma mark - http 确认提现

- (void)requestPayment {
    WEAK_SELF;
    NSString *encriptPassword = [MKTool md5_passwordEncryption:passwordInput];
    NSDictionary *praDic = @{@"money":_withdrawTextField.text ? _withdrawTextField.text : @"",
                             @"addres":_withdrawURL ? _withdrawURL : @"",
                             @"memo":_MemoTextField.text ? _MemoTextField.text : @"",
                             @"password" : encriptPassword};
    
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_walletWithdraw] params:praDic success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@" 确认提现%@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshWallet" object:nil];
            
            [UIView animateWithDuration:0.2 animations:^{
                 _popSuccesView.alpha = 1.0;
            }];
            
           [strongSelf performSelector:@selector(dismissViewController) withObject:nil afterDelay:2];
            
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

- (IBAction)nextStepClicked:(UIButton *)sender {
    [self.paymentView showInViewController:self];
    [self.paymentView configWithCoins:[NSString stringWithFormat:@"%@ TV",_withdrawTextField.text]];
}


- (void)dismissViewController {
    UIViewController *myWalletVC =  self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:myWalletVC animated:NO];
    
}

@end
