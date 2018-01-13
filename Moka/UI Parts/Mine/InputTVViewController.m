//
//  InputTVViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "InputTVViewController.h"
#import "TVLockSuccessViewController.h"
#import "TVfeedBackPlainViewController.h"
#import "MKRechargeCoinsViewController.h"

@interface InputTVViewController ()<UITextFieldDelegate>

//去充值
@property (strong, nonatomic) IBOutlet UIView *gotoInputView;
//我的钛值余额
@property (strong, nonatomic) IBOutlet UILabel *myTVBalanceLabel;
//输入框
@property (strong, nonatomic) IBOutlet UITextField *TVTextField;
//钛值回馈计划
- (IBAction)TVfeedBackPlainClick:(UIButton *)sender;

//确定锁定
@property (strong, nonatomic) IBOutlet UIButton *sureLockBtn;
- (IBAction)sureLockClick:(UIButton *)sender;
//
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation InputTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"锁定钛值";
    
    [self loadBaseSet];
    [self checkUserBalance];
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



#pragma mark -- 基础属性设置
-(void)loadBaseSet{
    
    //
    self.gotoInputView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicks:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    [self.gotoInputView addGestureRecognizer:tapGesture];
    
    //按钮
    self.sureLockBtn.layer.cornerRadius = 25.0f;
    //文本框
    self.TVTextField.delegate = self;
    self.TVTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
}

-(void)showNotice:(NSString *)text{
    //获取系统时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH"];
    NSString *DateTime = [formatter stringFromDate:date];
    //
    if ([text intValue] < 100) {
        self.noticeLabel.text = @"您的钛值余额不足，请先充值。";
    }else{
        if ([DateTime intValue] < 12) {
            self.noticeLabel.text = @"现在存入，今天开始算奖励，明天开始到账。";
        }else{
            self.noticeLabel.text = @"现在存入，明天开始算奖励，后天开始到账。";
        }
    }
}


-(void)tapClicks:(UITapGestureRecognizer *)tap{
    
    MKRechargeCoinsViewController * vc = [[MKRechargeCoinsViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


//确认锁定
- (IBAction)sureLockClick:(UIButton *)sender {
    
    BOOL isOK = [self checkTextField:_TVTextField.text];
    if (isOK) {
        [self requestLockTV];
    }
}
//计划说明
- (IBAction)TVfeedBackPlainClick:(UIButton *)sender {
    TVfeedBackPlainViewController * vc = [[TVfeedBackPlainViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- 查询TV余额
-(void)checkUserBalance{
    WEAK_SELF;
    [[MKNetworkManager sharedManager] get:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myBalance] params:nil success:^(id json) {
        STRONG_SELF;
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"充值查询 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        if (status == 200) {
            
            NSString * balanceStr = [NSString stringWithFormat:@"%.3f",[json[@"dataObj"][@"tvBalance"] integerValue] / 1000.0];
            self.myTVBalanceLabel.text = [NSString stringWithFormat:@"可用余额%@TV",balanceStr != nil ? balanceStr : @"可用余额0TV"];
            [self showNotice:balanceStr];
        }else{
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:strongSelf.view];
        }
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:strongSelf.view];
        DLog(@"%@",error);
    }];
}


#pragma mark --  锁定钛值
-(void)requestLockTV{
    
    NSDictionary * param = @{@"lockNum":_TVTextField.text ? _TVTextField.text : @""};
    
    WEAK_SELF;
    [MKUtilHUD showHUD:self.view];
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_feedBackLockTV] params:param success:^(id json) {
        STRONG_SELF;
        [MKUtilHUD hiddenHUD:strongSelf.view];
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"充值查询 %@",json);
        [MKUtilAction doApiTokenFailWithStatusCode:status inController:strongSelf];
        
        if (status == 200) {
            
            TVLockSuccessViewController * vc = [[TVLockSuccessViewController alloc]init];
            vc.Suc = self.toLockSuc;
            vc.startTimeStr = [NSString stringWithFormat:@"%@",json[@"dataObj"][@"startTime"]];
            [self.navigationController pushViewController:vc animated:YES];
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

-(BOOL)checkTextField:(NSString *)str{
    
    int pay = [str intValue];
    if (str.length == 0) {
        [MKUtilHUD showHUD:@"请输入锁定金额" inView:nil];
        return NO;
    }else{
        if (pay<100) {
            [MKUtilHUD showHUD:@"钛值最低锁定值100.000TV" inView:nil];
            return NO;
        }
    }
    return YES;
}


@end
