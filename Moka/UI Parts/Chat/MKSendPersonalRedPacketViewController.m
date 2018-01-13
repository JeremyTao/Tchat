//
//  MKSendPersonalRedPacketViewController.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKSendPersonalRedPacketViewController.h"
#import "InputLimitedTextView.h"
#import "MKJoinGroupPopView.h"
#import "MKConversationViewController.h"
#import "BalanceNoticeView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface MKSendPersonalRedPacketViewController ()<UITextFieldDelegate>

{
    NSString *totalCoins;
    NSString *passwordInput;
    NSString *redPacketTitle;
    NSString * _orderInfo;
    
}


@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *coinTypeLabel;

@property (weak, nonatomic) IBOutlet UITextField *coinTextField;
@property (weak, nonatomic) IBOutlet InputLimitedTextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *remianCoinLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendCoinLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
//支付密码
@property (strong, nonatomic) MKJoinGroupPopView *paymentView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hintLabelBottomConstraint;

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@end


@implementation MKSendPersonalRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.backgroundColor = RedPacketColor;
    WEAK_SELF;
    self.paymentView = [MKJoinGroupPopView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        NSLog(@"text = %@",text);
        passwordInput = text;
        [strongSelf requestSendPersonalRedPacket];
        [_paymentView hide];
        [strongSelf.view endEditing:YES];
    }];
    self.coinTextField.text = @"";
    //
    if ([self.coinType isEqualToString:@"1"]) {
        self.coinTypeLabel.text = @"元";
    }else{
        self.coinTypeLabel.text = @"TV";
    }
    self.coinTextField.delegate = self;
    [self.coinTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
    [self requestCoinsRemain];
}

- (void)textFieldChanged:(UITextField *)textField {

    totalCoins = textField.text;
    
    if ([textField.text floatValue] > 0){
        _hintLabelBottomConstraint.constant = 0;
        textField.textColor = RGB_COLOR_HEX(0x2A2A2A);
        _sendCoinLabel.textColor = RGB_COLOR_HEX(0x2A2A2A);
        _sendCoinLabel.hidden = NO;
        _lineView.hidden = NO;
        _sendButton.enabled = YES;
        _sendButton.backgroundColor = RedPacketColor;
    }
    
   
    
    [UIView animateWithDuration:0.4 animations:^{
        //[self.view layoutIfNeeded]; 解决UITextfield在切换焦点的里面文字都向上抖动一下或者说是跳动
        [self.view layoutSubviews];
    }];
    
    if ([self.coinType isEqualToString:@"1"]) {
        NSString *mkText =  [NSString stringWithFormat:@"%@ 元", textField.text];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:mkText attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:50], NSForegroundColorAttributeName: RedPacketColor}];
        
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(mkText.length - 2, 2)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x4A4A4A) range:NSMakeRange(mkText.length - 2, 2)];
        
        _sendCoinLabel.attributedText = attributedStr;
    }else{
        NSString *mkText =  [NSString stringWithFormat:@"%@ TV", textField.text];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:mkText attributes:              @{ NSFontAttributeName : [UIFont systemFontOfSize:41],NSForegroundColorAttributeName: RedPacketColor}];
        //
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(mkText.length - 3, 3)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x4A4A4A) range:NSMakeRange(mkText.length - 3, 3)];
        
        _sendCoinLabel.attributedText = attributedStr;
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.coinTextField) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        if ([self.coinType isEqualToString:@"1"]) {
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
        }else{
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
                            if (tt <= 3){
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
                            if (tt <= 3){
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
    }
    return YES;
}


- (void)textViewDidChange {
    redPacketTitle  = _titleTextView.text.length != 0 ? _titleTextView.text : _titleTextView.placeholder;
}

#pragma mark- HTTP 查询余额

- (void)requestCoinsRemain {
    
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL, api_myBalance] params:nil success:^(id json) {
        STRONG_SELF;
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"查询余额 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            if ([self.coinType isEqualToString:@"1"]) {
                strongSelf.remianCoinLabel.text = [NSString stringWithFormat:@"¥%.2f 元",[json[@"dataObj"][@"rmbBalance"] doubleValue]];
            }else{
                strongSelf.remianCoinLabel.text = [NSString stringWithFormat:@"%@ TV",[NSString removeFloatAllZero:[json[@"dataObj"][@"tvBalance"] integerValue] / 1000.0]];
            }
            
            
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


#pragma mark - HTTP 发送个人红包

- (void)requestSendPersonalRedPacket {
    
    NSString *encripPassword  = [MKTool md5_passwordEncryption:passwordInput];
    
    redPacketTitle  = _titleTextView.text.length != 0 ? _titleTextView.text : _titleTextView.placeholder;
    
    NSDictionary *paras = @{@"type":@"1",
                            @"money" : totalCoins.length > 0 ? totalCoins : @"0",
                            @"coinType":self.coinType,
                            @"number":@"1",
                            @"pwd"   : encripPassword,
                            @"targetId" : self.targetId,
                            @"remark": redPacketTitle,
                            };
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_sendPersRedPacket] params:paras success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"发送个人红包 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        
        if (status == 200) {
            
            MKRedPacketMessageContent *redPacketMessage = [[MKRedPacketMessageContent alloc] init];
            redPacketMessage.messageId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"uid"]];
            redPacketMessage.redPacketTitle = redPacketTitle;
            redPacketMessage.redPacketType = @"0";
            redPacketMessage.totalCoins  = totalCoins;
            redPacketMessage.numbersOfRedPacket = @"1";
            redPacketMessage.sendTime = [DateUtil getCurrentTime];
            redPacketMessage.status = @"0";
            redPacketMessage.coinType = self.coinType;
            redPacketMessage.senderName    = [MKChatTool sharedChatTool].currentUserInfo.name;
            redPacketMessage.senderPortait = [MKChatTool sharedChatTool].currentUserInfo.portraitUri;
            
            //通知传值 -> 聊天页面
            //个人红包
            NSNotification *notification = [NSNotification notificationWithName:@"sendRedSuc" object:nil userInfo:@{@"sendPSuc":redPacketMessage}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            //
            [strongSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            
        }else if (status == -100){
            
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:1 inView:strongSelf.view];
            //数据加载成功后执行；这里为了模拟加载效果，一秒后执行恢复原状代码
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [self toChargeBalance];
            });
            
        }else{
            
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:1 inView:strongSelf.view];
        }

        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
    
}


- (IBAction)cancleButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)sendRedPacketButtonClicked:(UIButton *)sender {
    
    BOOL isOK = [self checkRedAccount:_coinTextField.text];
    if (isOK) {
        [self.paymentView showInViewController:self];
        if ([self.coinType isEqualToString:@"1"]) {
            
            [self.paymentView configWithCoins:[NSString stringWithFormat:@"%@ 元",_coinTextField.text]];
            
        }else{
            [self.paymentView configWithCoins:[NSString stringWithFormat:@"%@ TV",_coinTextField.text]];
        }
        
    }
}


-(BOOL)checkRedAccount:(NSString *)tx{
    
    float account = [tx floatValue];
    if (account >1000000) {
        [MKUtilHUD showHUD:@"单次发送红包金额超出上限" inView:nil];
        return NO;
    }
    return YES;
}


#pragma mark -- 充值余额
-(void)toChargeBalance{
    
    BalanceNoticeView *balanceNotice = [[BalanceNoticeView alloc]initAlertView:@"余额不足" balance:[NSString stringWithFormat:@"余额:%@",self.remianCoinLabel.text]];
    
        balanceNotice.resultText = ^(NSString *text) {
        
            [self requestDatas:text];
    };
    
    [balanceNotice showAlertView];
    
}

#pragma mark -- 充值信息
-(void)requestDatas:(NSString *)money{
    
    //coinType 2 : RMB
    NSDictionary * param = @{@"money":money.length > 0 ? money : @"0",
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

//
-(void)wakeUpAlipay:(NSString *)orderStr{
    
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:ALIPAY_SCHEME callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}


@end
