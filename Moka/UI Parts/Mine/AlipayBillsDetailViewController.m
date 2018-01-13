//
//  AlipayBillsDetailViewController.m
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "AlipayBillsDetailViewController.h"

@interface AlipayBillsDetailViewController ()

//收入支出
@property (strong, nonatomic) IBOutlet UILabel *crashesLabel;
//金额
@property (strong, nonatomic) IBOutlet UILabel *crashLabel;
//类型
@property (strong, nonatomic) IBOutlet UILabel *crashTypeLabel;
//时间
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
//状态
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
//交易单号
@property (strong, nonatomic) IBOutlet UILabel *translateIDLabel;
//备注
@property (strong, nonatomic) IBOutlet UILabel *explainLabel;


@end

@implementation AlipayBillsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"详情";
    [self loadDatas];
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


#pragma mark -- 刷新界面
-(void)loadDatas{
    
    //时间
    self.timeLabel.text = [self changeToTime:self.time];
    //交易单号
    self.translateIDLabel.text = self.transID;
    //1：充值，2：提现，3：发个人红包，4：发圈子随机红包，5：发圈子固定红包 ，6：收到个人红包，7：收到圈子随机红包，8：收到圈子固定红包，9：红包退款，10：打赏别人，11：别人打赏，12：加入圈子，13：别人加入圈子
    switch ([self.type intValue]) {
        case 1:
        {
            self.crashesLabel.text = @"入账金额";
            self.explainLabel.text = @"充值";
            self.crashTypeLabel.text = @"收入";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 2:
        {
            self.crashesLabel.text = @"支出金额";
            self.explainLabel.text = @"提现";
            self.crashTypeLabel.text = @"支出";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            //
            if ([self.status intValue] == 0) {
                
                self.statusLabel.text = @"审核中";
            }else if ([self.status intValue] == 1){
                
                self.statusLabel.text = @"审核成功";
            }else if ([self.status intValue] == 2){
                
                self.statusLabel.text = @"审核失败";
            }
        }
            break;
        case 3:
        {
            self.crashesLabel.text = @"支出金额";
            self.explainLabel.text = @"个人红包";
            self.crashTypeLabel.text = @"支出";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 4:
        {
            self.crashesLabel.text = @"支出金额";
            self.explainLabel.text = @"圈子随机红包";
            self.crashTypeLabel.text = @"支出";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 5:
        {
            self.crashesLabel.text = @"支出金额";
            self.explainLabel.text = @"圈子固定红包";
            self.crashTypeLabel.text = @"支出";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 6:
        {
            self.crashesLabel.text = @"入账金额";
            self.explainLabel.text = [NSString stringWithFormat:@"个人红包-来自%@",self.remark];
            self.crashTypeLabel.text = @"收入";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 7:
        {
            self.crashesLabel.text = @"入账金额";
            self.explainLabel.text = [NSString stringWithFormat:@"圈子随机红包-来自%@",self.remark];
            self.crashTypeLabel.text = @"收入";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 8:
        {
            self.crashesLabel.text = @"入账金额";
            self.explainLabel.text = [NSString stringWithFormat:@"圈子固定红包-来自%@",self.remark];
            self.crashTypeLabel.text = @"收入";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 9:
        {
            self.crashesLabel.text = @"入账金额";
            self.explainLabel.text = @"红包退款";
            self.crashTypeLabel.text = @"收入";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 10:
        {
            self.crashesLabel.text = @"支出金额";
            self.explainLabel.text = @"打赏";
            self.crashTypeLabel.text = @"支出";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 11:
        {
            self.crashesLabel.text = @"入账金额";
            self.explainLabel.text = @"打赏";
            self.crashTypeLabel.text = @"收入";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 12:
        {
            self.crashesLabel.text = @"支出金额";
            self.explainLabel.text = @"加入圈子";
            self.crashTypeLabel.text = @"支出";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 13:
        {
            self.crashesLabel.text = @"入账金额";
            self.explainLabel.text = @"加入圈子";
            self.crashTypeLabel.text = @"收入";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[self.money doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        default:
            break;
    }
}

-(NSString *)changeToTime:(NSString *)timeStr{
    
    //生成的时间戳是10位
    NSTimeInterval interval = [timeStr doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    
    return dateString;
}

@end
