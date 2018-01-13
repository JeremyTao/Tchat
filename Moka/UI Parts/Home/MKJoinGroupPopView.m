//
//  MKGroupReviewPopView.m
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKJoinGroupPopView.h"
#import "MKSetPaymentPasswordViewController.h"

@interface MKJoinGroupPopView ()

@property (weak, nonatomic) IBOutlet UIButton *darkBackgoundButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic, strong) UIWindow      *popWindow;
@property (weak, nonatomic) IBOutlet MQVerCodeInputView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
//
@property (strong, nonatomic) IBOutlet UILabel *alipayFeeLabel;

@end

@implementation MKJoinGroupPopView

+ (instancetype)newPopViewWithInputBlock:(MQTextViewBlock)inputBlock {
    MKJoinGroupPopView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MKJoinGroupPopView" owner:nil options:nil] objectAtIndex:0];
    if ([customView isKindOfClass:[MKJoinGroupPopView class]]) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        customView.inputView.maxLenght = 6;//最大长度
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

- (void)showInViewController:(UIViewController *)vc {
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

- (void)configWithCoins:(NSString *)coins {
    
    _payLabel.text = [NSString stringWithFormat:@"%@", coins];
    _alipayFeeLabel.hidden = YES;
}

-(void)showPayFeeNoticeLabel:(NSString *)crashes{

    _payLabel.text = [NSString stringWithFormat:@"¥%@", crashes];
    float fee = [crashes floatValue] * 0.006;
    
    NSString * feeStr = @"0.6%";
    _alipayFeeLabel.text = [NSString stringWithFormat:@"扣除%@手续费,金额¥%.2f",feeStr,[self dealWithFees:fee]];
}


-(float)dealWithFees:(float) nums{
    float deal = nums;
    
    NSString * dealStr = [NSString stringWithFormat:@"%f",deal];
    if ([dealStr containsString:@"."]) {
        
        NSString * str = [[dealStr componentsSeparatedByString:@"."] lastObject];
        NSString * srt1 = [str substringWithRange:NSMakeRange(2,1)];
        
        NSLog(@"-------------第三位是----------%@",srt1);
        
        if ([srt1 intValue] > 0) {
            
            deal = deal + 0.01;
        }
        
    }
    return deal;
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
            
            [strongSelf.inputView becomeFirstResponder];
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
                        [vc presentViewController:payPasswordVC animated:YES completion:nil];
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
