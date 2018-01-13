//
//  MKSendGroupRedPacketViewController.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//
//#define HINT_TOTAL_LIMIT  @"单次支付总额不可超过200000MKC"
//#define HINT_MONEY_LIMIT  @"单个红包不可超过2000MKC"
#define HINT_COUNT_LIMIT  @"一次最多发100个红包"

#import "MKSendGroupRedPacketViewController.h"
#import "InputLimitedTextView.h"
#import "MKJoinGroupPopView.h"
#import "BalanceNoticeView.h"
#import <AlipaySDK/AlipaySDK.h>

typedef enum : NSUInteger {
    GroupRedPacketTypeLuck = 2,    //拼手气红包
    GroupRedPacketTypeNormal = 3  //普通红包
} GroupRedPacketType;

@interface MKSendGroupRedPacketViewController ()<UITextFieldDelegate>

{
    GroupRedPacketType myRedPacketType;
    CGFloat            totalCoins;       //总金额(拼手气)
    CGFloat            singleCoins;      //单个红包金额(普通)
    CGFloat            sumCoins;         //总红包金额(普通)
    NSInteger          redPacketNumber;  //红包个数
    NSString           *passwordInput;
    NSString           *redPacketTitle;
    NSString           *sendMoney;
    NSString           *_orderInfo;
}

//拼手气红包
@property (strong, nonatomic) IBOutlet UIButton *randomBtn;
@property (strong, nonatomic) IBOutlet UILabel *randomLabel;
- (IBAction)randomClicked:(UIButton *)sender;
//普通红包
@property (strong, nonatomic) IBOutlet UIButton *ordinaryBtn;
@property (strong, nonatomic) IBOutlet UILabel *ordinaryLabel;
- (IBAction)ordinaryClicked:(UIButton *)sender;
//金额类型
@property (strong, nonatomic) IBOutlet UILabel *moneyTypeLabel;
//余额
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
//全部钱的类型
@property (strong, nonatomic) IBOutlet UILabel *totleMoneyTypeLabel;
//
@property (weak, nonatomic) IBOutlet UITextField *coinTextField;
@property (weak, nonatomic) IBOutlet UILabel *luckMark; //"拼"字样
//
@property (weak, nonatomic) IBOutlet InputLimitedTextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel; //本圈子共10人

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@property (weak, nonatomic) IBOutlet UILabel *sendCoinLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) MKJoinGroupPopView *paymentView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hintLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UIView *navigationView;

@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;


@end

@implementation MKSendGroupRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.backgroundColor = RedPacketColor;
    
    //初始化设置
    [self.randomBtn setTitleColor:RGBCOLOR(230, 73, 78) forState:UIControlStateNormal];
    self.randomLabel.backgroundColor = RGBCOLOR(230, 73, 78);
    [self.ordinaryBtn setTitleColor:RGBCOLOR(102, 102, 102) forState:UIControlStateNormal];
    self.ordinaryLabel.backgroundColor = [UIColor whiteColor];
    //
    totalCoins = 0.;
    redPacketNumber = 1; //默认值
    myRedPacketType = GroupRedPacketTypeLuck;
    WEAK_SELF;
    self.paymentView = [MKJoinGroupPopView newPopViewWithInputBlock:^(NSString *text) {
        STRONG_SELF;
        NSLog(@"text = %@",text);
        passwordInput = text;
        //
        [strongSelf requestSendGroupRedPacket];
        [_paymentView hide];
        [strongSelf.view endEditing:YES];
    }];
    self.coinTextField.delegate = self;
    [self.coinTextField addTarget:self action:@selector(textFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.countTextField addTarget:self action:@selector(countTextFieldChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.peopleNumLabel.text = [NSString stringWithFormat:@"本圈子共%ld人", (long)_numberOfPeople];
    
    //
    if ([self.coinType isEqualToString:@"1"]) {
        self.moneyTypeLabel.text = @"元";
        self.totleMoneyTypeLabel.text = @"元";
    }else{
        self.moneyTypeLabel.text = @"TV";
        self.totleMoneyTypeLabel.text = @"TV";
    }
    //
    [self requestCoinsRemain];
}

- (void)textFieldChanged:(UITextField *)textField {
    
    if (myRedPacketType == GroupRedPacketTypeLuck) {
        [self checkInputOnLuckRedPacketWith:textField];
    } else {
        [self checkInputOnNormalRedPacketWith:textField];
    }
}

//发送红包
- (IBAction)sendRedPacketButtonClicked:(UIButton *)sender {
    
    BOOL isOK = [self checkGroupRedAccount:_coinTextField.text];
    if (isOK) {
        if (_sendCoinLabel.attributedText.length > 0) {
            sendMoney = _sendCoinLabel.text;
            DLog(@"money = %@", sendMoney);
            if ([sendMoney floatValue] > 0) {
                [self.paymentView showInViewController:self];
                if([self.coinType isEqualToString:@"1"]){
                    
                    [self.paymentView configWithCoins:[NSString stringWithFormat:@"%@ 元",sendMoney]];
                }else{
                    
                    [self.paymentView configWithCoins:[NSString stringWithFormat:@"%@ TV",sendMoney]];
                }
                
            }
            
        }
    }
    
}

-(BOOL)checkGroupRedAccount:(NSString *)tx{
    
    int account = [tx intValue];
    if (account >1000000) {
        [MKUtilHUD showHUD:@"单次发送红包金额超出上限" inView:nil];
        return NO;
    }
    return YES;
}

#pragma mark -- 充值余额
-(void)toChargeBalance{
    
    BalanceNoticeView *balanceNotice = [[BalanceNoticeView alloc]initAlertView:@"余额不足" balance:[NSString stringWithFormat:@"余额:%@",self.balanceLabel.text]];
    
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





#pragma mark - HTTP 发送群红包

- (void)requestSendGroupRedPacket {

    NSString *encripPassword  = [MKTool md5_passwordEncryption:passwordInput];
    NSString *type = nil;
    if (myRedPacketType == GroupRedPacketTypeLuck) {
        type = @"2";
    } else {
        type = @"3";
    }

    redPacketTitle  = _titleTextView.text.length != 0 ? _titleTextView.text : _titleTextView.placeholder;

    NSDictionary *paras = @{@"type"  : type,
                            @"money" : sendMoney,
                            @"coinType":self.coinType,
                            @"number": @(redPacketNumber),
                            @"pwd"   : encripPassword,
                            @"targetId":self.circleId,
                            @"remark": redPacketTitle,
                            };
    DLog(@"群红包参数 %@", paras);
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_sendPersRedPacket] params:paras success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:self.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"发送群红包 %@",json);
            [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];

        if (status == 200) {

            MKRedPacketMessageContent *redPacketMessage = [[MKRedPacketMessageContent alloc] init];
            redPacketMessage.messageId = [NSString stringWithFormat:@"%@", json[@"dataObj"][@"uid"]];
            redPacketMessage.redPacketTitle = redPacketTitle;
            redPacketMessage.redPacketType = type;
            redPacketMessage.totalCoins  = sendMoney;
            redPacketMessage.numbersOfRedPacket = [NSString stringWithFormat:@"%ld", (long)redPacketNumber];
            redPacketMessage.sendTime = [DateUtil getCurrentTime];
            redPacketMessage.status = @"0";
            redPacketMessage.coinType = self.coinType;

            redPacketMessage.senderName    = [MKChatTool sharedChatTool].currentUserInfo.name;
            redPacketMessage.senderPortait = [MKChatTool sharedChatTool].currentUserInfo.portraitUri;
            
            //通知传值
            //通知传值 -> 聊天页面
            //群红包
            NSNotification *notification = [NSNotification notificationWithName:@"sendGroupRedSuc" object:nil userInfo:@{@"sendGSuc":redPacketMessage}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];

            [strongSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];


        }else if (status == -100)
        {
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




- (void)checkInputOnNormalRedPacketWith:(UITextField *) textField {
    if (textField.text.length > 12) {
        textField.text = [textField.text substringToIndex:12];
    }
    
    
    
    if ([textField.text floatValue] > 0) {
       
        _hintLabelBottomConstraint.constant = 0;
        textField.textColor = RGB_COLOR_HEX(0x2A2A2A);
        _sendCoinLabel.textColor = RGB_COLOR_HEX(0xE6494E);
        _sendCoinLabel.hidden = NO;
        _lineView.hidden = NO;
        _sendButton.enabled = YES;
        _sendButton.backgroundColor = RedPacketColor;
        [self autoLayoutAnimation];
    }
    
    singleCoins = [textField.text floatValue];
    [self calculateTotalMoneyInNormalRedPacket];
    
    
    if (myRedPacketType == GroupRedPacketTypeLuck) {
        NSString *mkText;
        if ([self.coinType isEqualToString:@"1"]) {
             mkText =  [NSString stringWithFormat:@"%.2f", singleCoins];
        }else{
             mkText =  [NSString stringWithFormat:@"%.3f", singleCoins];
        }
        //
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:mkText attributes:               @{ NSFontAttributeName : [UIFont systemFontOfSize:41],
                                                                                                                                         NSForegroundColorAttributeName: RGB_COLOR_HEX(0xE6494E)}];
        _sendCoinLabel.attributedText = attributedStr;
    }
}

//红包个数改变
- (void)countTextFieldChanged:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        redPacketNumber = 1;
        if (myRedPacketType == GroupRedPacketTypeNormal) {
            [self calculateTotalMoneyInNormalRedPacket];
        }
        return;
    }
    
    
    if ([textField.text integerValue] == 0) {
        textField.text = @"";
        redPacketNumber = 1;
        if (myRedPacketType == GroupRedPacketTypeNormal) {
            [self calculateTotalMoneyInNormalRedPacket];
        }
    } else {
        
        
        if (textField.text.length > 3) {
            //最多输入3位数字
            textField.text = [textField.text substringToIndex:3];
        }
        
        redPacketNumber = [textField.text integerValue];
        
        if (redPacketNumber > 100) {
            //提示一次最多发100个红包
            textField.textColor = RedPacketColor;
            _hintLabel.text = HINT_COUNT_LIMIT;
            _hintLabelBottomConstraint.constant = 36;
            [self autoLayoutAnimation];
            return;
        } else {
            textField.textColor = RGB_COLOR_HEX(0x2A2A2A);
            _hintLabelBottomConstraint.constant = 0;
            [self autoLayoutAnimation];
        }
        
        if (myRedPacketType == GroupRedPacketTypeNormal) {
            [self calculateTotalMoneyInNormalRedPacket];
        }
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

- (void)checkInputOnLuckRedPacketWith:(UITextField *) textField {
    if (textField.text.length > 12) {
        textField.text = [textField.text substringToIndex:12];
    }
    
    totalCoins = [textField.text floatValue];
    
    NSString *mkText;
    if ([self.coinType isEqualToString:@"1"]) {
        mkText =  [NSString stringWithFormat:@"%.2f", totalCoins];
    }else{
        mkText =  [NSString stringWithFormat:@"%.3f", totalCoins];
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:mkText attributes:               @{ NSFontAttributeName : [UIFont systemFontOfSize:41],
                                                                                                                                     NSForegroundColorAttributeName: RGB_COLOR_HEX(0xE6494E)}];
    
    _sendCoinLabel.attributedText = attributedStr;

    
    if (redPacketNumber == 1) {
        //还没有设置红包个数，直接显示金额
        
        _sendCoinLabel.hidden = NO;
        _lineView.hidden = NO;
        _sendButton.enabled = YES;
        _sendButton.backgroundColor = RedPacketColor;
    } else {
        
        //设置了红包个数，计算单个红包金额
//        CGFloat singlePacket = [textField.text floatValue] / redPacketNumber;
//        if (singlePacket > 2000) {
//            //提示单个红包不超过2000
//            _hintLabel.text = HINT_MONEY_LIMIT;
//            textField.textColor = RedPacketColor;
//            _hintLabelBottomConstraint.constant = 36;
//            _sendButton.enabled = NO;
//            _sendButton.backgroundColor = RGB_COLOR_HEX(0xE5E5E5);
//            [self autoLayoutAnimation];
//            return;
//        } else {
//            _hintLabelBottomConstraint.constant = 0;
//            _sendButton.enabled = YES;
//            textField.textColor = RGB_COLOR_HEX(0x2A2A2A);
//            _sendButton.backgroundColor = RedPacketColor;
//            [self autoLayoutAnimation];
//        }
        
      
        
    }
    
    
    //判断总金额
//    if (totalCoins > 200000) {
//        _hintLabel.text = HINT_TOTAL_LIMIT;
//        _hintLabelBottomConstraint.constant = 36;
//        textField.textColor = RedPacketColor;
//        _sendButton.enabled = NO;
//        _sendButton.backgroundColor = RGB_COLOR_HEX(0xE5E5E5);
//        [self autoLayoutAnimation];
//        return;
//    }else {
//        _hintLabelBottomConstraint.constant = 0;
//        textField.textColor = RGB_COLOR_HEX(0x2A2A2A);
//        _sendButton.enabled = YES;
//        _sendButton.backgroundColor = RedPacketColor;
//        [self autoLayoutAnimation];
//    }
//    
    
    

}

//计算红包里金额总数
- (void)calculateTotalMoneyInNormalRedPacket {
    
    if (myRedPacketType == GroupRedPacketTypeNormal) {
        sumCoins = singleCoins * redPacketNumber ;
    }
    NSString *mkText;
    if ([self.coinType isEqualToString:@"1"]) {
        mkText =  [NSString stringWithFormat:@"%.2f",sumCoins];
    }else{
        mkText =  [NSString stringWithFormat:@"%.3f",sumCoins];
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:mkText attributes:               @{ NSFontAttributeName : [UIFont systemFontOfSize:41],
                                                                                                                                     NSForegroundColorAttributeName: RGB_COLOR_HEX(0xE6494E)}];
    
    _sendCoinLabel.attributedText = attributedStr;
}

- (void)autoLayoutAnimation {
    [UIView animateWithDuration:0.4 animations:^{
        //[self.view layoutIfNeeded]; 解决UITextfield在切换焦点的里面文字都向上抖动一下或者说是跳动
        [self.view layoutSubviews];
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

#pragma mark -- 拼手气红包
- (IBAction)randomClicked:(UIButton *)sender {
    
    myRedPacketType = GroupRedPacketTypeLuck;
    _luckMark.hidden = NO;
    //
    [self.randomBtn setTitleColor:RGBCOLOR(230, 73, 78) forState:UIControlStateNormal];
    self.randomLabel.backgroundColor = RGBCOLOR(230, 73, 78);
    [self.ordinaryBtn setTitleColor:RGBCOLOR(102, 102, 102) forState:UIControlStateNormal];
    self.ordinaryLabel.backgroundColor = [UIColor whiteColor];
    
    //数据清空
    totalCoins = 0.f;
    singleCoins = 0.f;
    redPacketNumber = 1;
    
    _coinTextField.text = @"";
    _countTextField.text = @"";
    [_coinTextField becomeFirstResponder];
    
    _sendCoinLabel.hidden = YES;
    _lineView.hidden = YES;
    _sendButton.enabled = NO;
    _sendButton.backgroundColor = RGB_COLOR_HEX(0xE5E5E5);
    
    _hintLabelBottomConstraint.constant = 0;
    [self autoLayoutAnimation];
}


#pragma mark -- 普通红包
- (IBAction)ordinaryClicked:(UIButton *)sender {
    
    myRedPacketType = GroupRedPacketTypeNormal;
    _luckMark.hidden = YES;
    //
    [self.randomBtn setTitleColor:RGBCOLOR(102, 102, 102) forState:UIControlStateNormal];
    self.randomLabel.backgroundColor = [UIColor whiteColor];
    [self.ordinaryBtn setTitleColor:RGBCOLOR(230, 73, 78) forState:UIControlStateNormal];
    self.ordinaryLabel.backgroundColor = RGBCOLOR(230, 73, 78);
    //数据清空
    totalCoins = 0.f;
    singleCoins = 0.f;
    redPacketNumber = 1;
    
    _coinTextField.text = @"";
    _countTextField.text = @"";
    [_coinTextField becomeFirstResponder];
    
    _sendCoinLabel.hidden = YES;
    _lineView.hidden = YES;
    _sendButton.enabled = NO;
    _sendButton.backgroundColor = RGB_COLOR_HEX(0xE5E5E5);
    
    _hintLabelBottomConstraint.constant = 0;
    [self autoLayoutAnimation];
    
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
                strongSelf.balanceLabel.text = [NSString stringWithFormat:@"¥%.2f",[json[@"dataObj"][@"rmbBalance"] doubleValue]];
            }else{
                strongSelf.balanceLabel.text = [NSString stringWithFormat:@"%@ TV",[NSString removeFloatAllZero:[json[@"dataObj"][@"tvBalance"] integerValue] / 1000.0]];
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

@end
