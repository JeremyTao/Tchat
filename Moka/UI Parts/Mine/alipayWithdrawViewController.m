//
//  alipayWithdrawViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "alipayWithdrawViewController.h"
#import "MKJoinGroupPopView.h"
#import "withDrawSucViewController.h"
#import "MKTool.h"

@interface alipayWithdrawViewController ()<UITextFieldDelegate>
{
    NSString *passwordInput;
}
//昵称
@property (strong, nonatomic) IBOutlet UILabel *UserNickNameLabel;
//号码
@property (strong, nonatomic) IBOutlet UILabel *alipayNumberLabel;
//提现文本框
@property (strong, nonatomic) IBOutlet UITextField *crashTextField;
//申请提现
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
//支付密码
@property (strong, nonatomic) MKJoinGroupPopView *paymentView;
- (IBAction)sureBtnClicked:(UIButton *)sender;

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;


@end

@implementation alipayWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"提现至支付宝";
    WEAK_SELF;
    self.paymentView = [MKJoinGroupPopView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        NSLog(@"text = %@",text);
        passwordInput = text;
        [strongSelf requestChargeDatas];
        [_paymentView hide];
        [strongSelf.view endEditing:YES];
    }];
    self.alipayNumberLabel.hidden = YES;
    [self setBaseViews];
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

-(void)setBaseViews{
    
    self.UserNickNameLabel.text = self.nickName;
    self.sureBtn.layer.cornerRadius = 25.0f;
    //Textfield
    self.crashTextField.delegate = self;
    self.crashTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.crashTextField.placeholder = [NSString stringWithFormat:@"可提现%.2f(最低100.00元)",[self.alipayBalance doubleValue]];
    
    [self.crashTextField setValue:RGBCOLOR(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.crashTextField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    self.crashTextField.tintColor = RGBCOLOR(204, 204, 204);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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


#pragma mark -- 申请提现
- (IBAction)sureBtnClicked:(UIButton *)sender {
    
    BOOL isOk = [self checkNumbers];
    if (isOk) {
        [self.paymentView showInViewController:self];
        [self.paymentView showPayFeeNoticeLabel:self.crashTextField.text];
    }
}


//限制输入金额
-(BOOL)checkNumbers{
    
    float crash = [self.crashTextField.text floatValue];
    if (crash<100) {
        [MKUtilHUD showHUD:@"最小提现金额不得低于100" inView:nil];
        return NO;
    }
    return YES;
}


#pragma mark -- 请求提现接口
-(void)requestChargeDatas{
    
    NSString *encripPassword  = [MKTool md5_passwordEncryption:passwordInput];
    
    NSDictionary * param = @{@"accountType":@"0",
                             @"money":self.crashTextField.text.length > 0 ? self.crashTextField.text : @"0",
                             @"password":encripPassword
                             };
    
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_alipayWithDraw] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"零钱提现信息 %@",json);
        if (status == 200) {
         
            NSString * state = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"status"]];
            if ([state isEqualToString:@"0"]) {
                withDrawSucViewController * vc = [[withDrawSucViewController alloc]init];
                vc.status = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"status"]];
                vc.money = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"money"]];
                vc.fee = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"fee"]];
                vc.account = self.nickName;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([state isEqualToString:@"1"]){
                
                [self showSuccessAlert];
            }
            
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

-(void)showSuccessAlert{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"到账成功" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
