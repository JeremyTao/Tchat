//
//  MKTotalInfoCell.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKInOutRedPacketModel.h"
#import "MKPayRedPacketModel.h"

@interface MKTotalInfoCell : UITableViewCell

//收到的红包
- (void)RMBConfigTotalInfoWith:(MKInOutRedPacketModel *)model;
- (void)TVConfigTotalInfoWith:(MKInOutRedPacketModel *)model;
//发出的红包
- (void)RMBConfigTotalOutInfoWith:(MKPayRedPacketModel *)model;
- (void)TVConfigTotalOutInfoWith:(MKPayRedPacketModel *)model;

@end
