//
//  alipayChargeBillsCell.m
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "alipayChargeBillsCell.h"

@implementation alipayChargeBillsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(alipayChargeBillModel *)model{
    
    _model = model;
    //时间
    self.dateLabel.text = [self changeToTime:_model.time];
    //1：充值，2：提现，3：发个人红包，4：发圈子随机红包，5：发圈子固定红包 ，6：收到个人红包，7：收到圈子随机红包，8：收到圈子固定红包，9：红包退款，10：打赏别人，11：别人打赏，12：加入圈子，13：别人加入圈子
    switch (_model.type) {
        case 1:
        {
            self.nameLabel.text = @"充值";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 2:
        {
            self.nameLabel.text = @"提现";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            //
            if (_model.status == 0) {
                
                self.statusLabel.text = @"审核中";
            }else if (_model.status == 1){
                
                self.statusLabel.text = @"审核成功";
            }else if (_model.status == 2){
                
                self.statusLabel.text = @"审核失败";
            }
        }
            break;
        case 3:
        {
            self.nameLabel.text = @"个人红包";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 4:
        {
            self.nameLabel.text = @"圈子随机红包";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 5:
        {
            self.nameLabel.text = @"圈子固定红包";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 6:
        {
            if (_model.repkUserName == nil) {
                self.nameLabel.text = [NSString stringWithFormat:@"个人红包-来自%@",_model.name];
            }else{
                self.nameLabel.text = [NSString stringWithFormat:@"个人红包-来自%@",_model.repkUserName];
            }
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 7:
        {
            if (_model.repkUserName == nil) {
                self.nameLabel.text = [NSString stringWithFormat:@"圈子随机红包-来自%@",_model.name];
            }else{
                self.nameLabel.text = [NSString stringWithFormat:@"圈子随机红包-来自%@",_model.repkUserName];
            }
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 8:
        {
            if (_model.repkUserName == nil) {
                self.nameLabel.text = [NSString stringWithFormat:@"圈子固定红包-来自%@",_model.name];
            }else{
                self.nameLabel.text = [NSString stringWithFormat:@"圈子固定红包-来自%@",_model.repkUserName];
            }
            
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 9:
        {
            self.nameLabel.text = @"红包退款";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 10:
        {
            self.nameLabel.text = @"打赏";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 11:
        {
            self.nameLabel.text = @"打赏";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(230, 73, 78);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 12:
        {
            self.nameLabel.text = @"加入圈子";
            self.crashLabel.text = [NSString stringWithFormat:@"-%.2f",[_model.totalMoney doubleValue]];
            self.crashLabel.textColor = RGBCOLOR(42, 42, 42);
            self.statusLabel.text = @"交易成功";
        }
            break;
        case 13:
        {
            self.nameLabel.text = @"加入圈子";
            self.crashLabel.text = [NSString stringWithFormat:@"+%.2f",[_model.totalMoney doubleValue]];
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
    NSTimeInterval interval    =[timeStr doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    
    return dateString;
}


@end
