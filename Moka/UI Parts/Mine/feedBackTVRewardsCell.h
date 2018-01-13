//
//  feedBackTVRewardsCell.h
//  Moka
//
//  Created by btc123 on 2017/12/6.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "feedBackTVRewardModel.h"

@interface feedBackTVRewardsCell : UITableViewCell

//日期
@property (strong, nonatomic) IBOutlet UILabel *TVRewardTimeLabel;
//收入
@property (strong, nonatomic) IBOutlet UILabel *TVRewardGetLabel;
//明细
@property (strong, nonatomic) IBOutlet UILabel *TVRewardSumLabel;

@property (nonatomic,strong) feedBackTVRewardModel * model;
@end
