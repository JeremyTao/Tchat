//
//  AlipayChargeViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "AlipayChargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayWalletViewController.h"

@interface AlipayChargeViewController ()<UITextFieldDelegate>
{
    NSString *_orderInfo;
}
//文本框
@property (strong, nonatomic) IBOutlet UITextField *crashTextField;
//零钱余额
@property (strong, nonatomic) IBOutlet UILabel *chargeLabel;
//按钮充值
@property (strong, nonatomic) IBOutlet UIButton *chargeBtn;
- (IBAction)chargeClicked:(UIButton *)sender;

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@end

@implementation AlipayChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"充值零钱";
    [self loadBaseViews];
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(charge:) name:@"AlipayCharge"object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)charge:(NSNotification *)noti{
    
    if ([noti.userInfo[@"result"] isEqualToString:@"9000"] || [noti.userInfo[@"result"] isEqualToString:@"8000"]) {
        //充值成功
        [MKUtilHUD showHUD:@"充值成功" inView:nil];
        for (AlipayWalletViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass: [AlipayWalletViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    if ([noti.userInfo[@"result"] isEqualToString:@"6001"]) {
        
        [MKUtilHUD showHUD:@"用户中途取消" inView:nil];
    }
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlipayCharge" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 基础设置
-(void)loadBaseViews{
    
    //Button
    self.chargeBtn.layer.cornerRadius = 25.0f;
    //Textfield
    self.crashTextField.delegate = self;
    self.crashTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.chargeLabel.text = [NSString stringWithFormat:@"%.2f元",[self.myBalance doubleValue]];
}


#pragma mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.crashTextField) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.'){
                        //首字母不能为小数点
                        return NO;
                    }
                    if (single == '0') {
                        _isFirstZero = YES;
                        return YES;
                    }
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.00"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


#pragma mark -- 数据请求

-(void)requestDatas{
    
    NSDictionary * param = @{@"money":self.crashTextField.text.length > 0 ? self.crashTextField.text : @"0",
                             @"coinType":@"2",
                             @"method":@"0"
                             };
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_alipayCharge] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"零钱充值信息 %@",json);
        if (status == 200) {
            
            
            _orderInfo = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"orderInfo"]];
            //
            [self wakeUpAlipay:_orderInfo];
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


//充值
- (IBAction)chargeClicked:(UIButton *)sender {
    
    BOOL isOk = [self checkNumbers];
    if (isOk) {
        [self requestDatas];
    }
}
//限制输入金额
-(BOOL)checkNumbers{
    
    float crash = [self.crashTextField.text floatValue];
    if (crash<0.01) {
        [MKUtilHUD showHUD:@"最小充值金额不得小于0.01" inView:nil];
        return NO;
    }else if (crash > 100000000){
        [MKUtilHUD showHUD:@"最大充值金额不得大于100000000" inView:nil];
        return NO;
    }
    
    return YES;
}

//
-(void)wakeUpAlipay:(NSString *)orderStr{
    
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:ALIPAY_SCHEME callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}
@end
