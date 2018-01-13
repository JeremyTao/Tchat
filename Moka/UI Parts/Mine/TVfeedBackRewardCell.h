//
//  TVfeedBackRewardCell.h
//  Moka
//
//  Created by btc123 on 2017/12/6.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVfeedBackRewardModel.h"

@interface TVfeedBackRewardCell : UITableViewCell

//锁定金额
@property (strong, nonatomic) IBOutlet UILabel *lockSumLabel;
//锁定时间
@property (strong, nonatomic) IBOutlet UILabel *lockTimeLabel;
//累计发放金额
@property (strong, nonatomic) IBOutlet UILabel *rewardSumLabel;
//多少期
@property (strong, nonatomic) IBOutlet UILabel *lockDataLabel;
//状态
@property (strong, nonatomic) IBOutlet UILabel *lockStatusLabel;
//解锁时间
@property (strong, nonatomic) IBOutlet UILabel *openTimeLabel;

@property (nonatomic,strong) TVfeedBackRewardModel * model;
@end
