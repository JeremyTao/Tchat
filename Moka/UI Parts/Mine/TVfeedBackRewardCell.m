//
//  TVfeedBackRewardCell.m
//  Moka
//
//  Created by btc123 on 2017/12/6.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "TVfeedBackRewardCell.h"

@implementation TVfeedBackRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.openTimeLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(TVfeedBackRewardModel *)model{
    _model = model;
    
    NSString * lockSumStr = [NSString stringWithFormat:@"%ld",(long)_model.locknum];
    //锁定的金额
    self.lockSumLabel.text = [NSString stringWithFormat:@"%.3f",[lockSumStr doubleValue]/1000.0];
    //锁定时间
    NSString * lockTime = [[_model.locktimes componentsSeparatedByString:@" "] firstObject];
    self.lockTimeLabel.text = lockTime;
    //回馈
    NSString * rewardSumStr = [NSString stringWithFormat:@"%ld",(long)_model.givedInterest];
    self.rewardSumLabel.text = [NSString stringWithFormat:@"%.3f",[rewardSumStr doubleValue]/1000.0];
    //期数
    self.lockDataLabel.text = [NSString stringWithFormat:@"%d/180期",_model.backnum];
    //状态
    if (_model.islocal == 0) {
        self.lockStatusLabel.text = @"锁定中";
        self.openTimeLabel.hidden = YES;
    }else{
        self.lockStatusLabel.text = @"已解锁";
        self.openTimeLabel.hidden = NO;
        NSString * openTime = [[_model.endtimes componentsSeparatedByString:@" "] firstObject];
        self.openTimeLabel.text = openTime;
    }
    
}

@end
