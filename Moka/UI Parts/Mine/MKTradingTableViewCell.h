//
//  MKTradingTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKMyAllRedPacketModel.h"
#import "MKMyWithdrawModel.h"
#import "MKRechargeModel.h"
#import "MKMyICOModel.h"
#import "MKMyAllGiftModel.h"
#import "MKMyAllRewardModel.h"
#import "MKCircleJoinModel.h"
@interface MKTradingTableViewCell : UITableViewCell

- (void)configRedPacketCellWith:(MKMyAllRedPacketModel *)redPacketmodel;
- (void)configWithdrawCellWith:(MKMyWithdrawModel *)withdrawModel;
- (void)configRechargeCellWith:(MKRechargeModel *)rechargeModel;
- (void)configICOCellWith:(MKMyICOModel *)icoModel;
- (void)configGiftCellWith:(MKMyAllGiftModel *)giftModel;
- (void)configMyAllRewardModelCellWith:(MKMyAllRewardModel *)rewardModel;
- (void)configCircleJoinCellWith:(MKCircleJoinModel *)circleModel;

@end
