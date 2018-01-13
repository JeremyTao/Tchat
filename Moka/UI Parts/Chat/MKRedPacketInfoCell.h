//
//  MKRedPacketInfoCell.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPersonalRedPacketDetailModel.h"
#import "MKGroupRedPacketDetailModel.h"
#import "NewGroupDetailModel.h"
#import "MKPeopleGetMoneyModel.h"

@interface MKRedPacketInfoCell : UITableViewCell

- (void)configGroupRedWith:(NewGroupDetailModel *)groupRedModel;
//群红包
- (void)RMBConfigGroupRedWith:(NewGroupDetailModel *)groupRedModel;
- (void)TVConfigGroupRedWith:(NewGroupDetailModel *)groupRedModel;

@end
