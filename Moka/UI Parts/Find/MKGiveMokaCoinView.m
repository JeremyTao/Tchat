//
//  MKGiveMokaCoinView.m
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGiveMokaCoinView.h"
#import "MKSetPaymentPasswordViewController.h"

@interface MKGiveMokaCoinView ()<UITextFieldDelegate>

{
    NSString *remainCount;
    UIViewController *currentViewController;
}

@property (weak, nonatomic) IBOutlet UIButton *darkBackgoundButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic, strong) UIWindow      *popWindow;

@property (weak, nonatomic) IBOutlet UIView *payMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@end

@implementation MKGiveMokaCoinView

+ (instancetype)newPopViewWithInputBlock:(MQTextViewBlock)inputBlock {
    MKGiveMokaCoinView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKGiveMokaCoinView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKGiveMokaCoinView class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        customView.inputView.maxLenght = 6;//最大长度
        customView.inputView.redBoarder = YES;
        
        customView.inputView.keyBoardType = UIKeyboardTypeNumberPad;
        [customView.inputView mq_verCodeViewWithMaxLenght];
        customView.inputView.viewColor = RGB_COLOR_HEX(0xB3B3B3);
        customView.inputView.viewColorHL = RGB_COLOR_HEX(0xB3B3B3);
        
        customView.inputView.block = inputBlock;
        
        return customView;
    }
    else
        return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _payMoneyView.layer.borderWidth = 0.5;
    _payMoneyView.layer.borderColor = RGB_COLOR_HEX(0xB3B3B3).CGColor;
    _popUpView.clipsToBounds = NO;
    self.inputMoneyTextField.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _payMoneyView.layer.borderColor = RedPacketColor.CGColor;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _payMoneyView.layer.borderColor = RGB_COLOR_HEX(0xB3B3B3).CGColor;
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.inputMoneyTextField) {
        
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
                        if([textField.text isEqualToString:@"0.0"]){
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



- (void)showInViewController:(UIViewController *)vc {
    
    currentViewController = vc;
    
    [self requestPaymentPasswordSetStatusController:vc];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.darkBackgoundButton.alpha = 0;
        self.popUpView.alpha = 0;
        self.popUpView.transform =  CGAffineTransformMakeScale(0.6, 0.6);;
    } completion:^(BOOL finished) {
        self.popWindow.hidden = YES;
        self.popWindow = nil;
    }];
    
}

- (IBAction)darkBackgroundButtonClicked:(UIButton *)sender {
    [self hide];
}

- (UIWindow *)popWindow {
    if (!_popWindow) {
        _popWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _popWindow.backgroundColor = [UIColor clearColor];
        _popWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return _popWindow;
}

- (IBAction)moneyButtonClicked:(id)sender {
    [_inputMoneyTextField becomeFirstResponder];
}


#pragma mark- HTTP 查询余额

- (void)requestCoinsRemain {
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_myBalance] params:nil success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"查询余额 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:currentViewController];
        
        if (status == 200) {
            
            remainCount = [NSString stringWithFormat:@"%.3f@", [json[@"dataObj"][@"tvBalance"] integerValue] / 1000.0];
            strongSelf.remainMoneyLabel.text = [NSString stringWithFormat:@"余额：%@ TV",[NSString removeFloatAllZero:[json[@"dataObj"][@"tvBalance"] integerValue] / 1000.0]];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:currentViewController.view];
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"%@",error);
    }];
    
}



#pragma mark - http  检查用户是否设置支付密码
- (void)requestPaymentPasswordSetStatusController:(UIViewController *)vc {
    NSDictionary *param = @{};
    WEAK_SELF;
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL,api_checkPayPasswordSet] params:param success:^(id json) {
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        NSInteger ifPassword = [json[@"dataObj"] integerValue] ;
        NSLog(@"检查用户是否设置支付密码 %@",json);
        if (status == 200 && ifPassword == 1) {
            
            [strongSelf requestCoinsRemain];
            
            strongSelf.inputMoneyTextField.text = nil;
            [strongSelf.inputView resetTextView];
            [strongSelf.inputMoneyTextField becomeFirstResponder];
            strongSelf.popWindow.rootViewController = vc;
            [strongSelf.popWindow addSubview:self];
            [strongSelf.popWindow makeKeyAndVisible];
            [strongSelf layoutIfNeeded];
            strongSelf.darkBackgoundButton.alpha = 0;
            strongSelf.popUpView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                strongSelf.darkBackgoundButton.alpha = 0.5;
                strongSelf.popUpView.alpha = 1.0;
                strongSelf.popUpView.transform =  CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                strongSelf.darkBackgoundButton.enabled = YES;
            }];
            
        } else {
            
            if (ifPassword == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未设置支付密码" message:@"设置支付密码之后，可以使用TV进行打赏，加入付费圈子以及发红包" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    MKSetPaymentPasswordViewController *payPasswordVC = [[MKSetPaymentPasswordViewController alloc] init];
                    
                    
                    if (vc.navigationController) {
                        [vc.navigationController pushViewController:payPasswordVC animated:YES];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedSetPassword" object:nil];
                    }
                    
                    
                }]];
                
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                
                [vc presentViewController:alertController animated:YES completion:nil];
            } else {
                [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:vc.view];
            }
            
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}


@end
