//
//  feedBackTVRewardsCell.m
//  Moka
//
//  Created by btc123 on 2017/12/6.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "feedBackTVRewardsCell.h"

@implementation feedBackTVRewardsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setModel:(feedBackTVRewardModel *)model{
    _model = model;
    
    //锁定时间
    NSString * lockTime = [[_model.createtime componentsSeparatedByString:@" "] firstObject];
    self.TVRewardTimeLabel.text = lockTime;
    //收入
    self.TVRewardGetLabel.text = @"收入";
    //每日回馈TV数量
    NSString * rewardSumStr = [NSString stringWithFormat:@"%ld",_model.dayinterest];
    self.TVRewardSumLabel.text = [NSString stringWithFormat:@"+%.3fTV",[rewardSumStr doubleValue]/1000.0];
    
}

@end
