//
//  MKIncomePeopleCell.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKRedListModel.h"
#import "MKRedPaymodel.h"

@interface MKIncomePeopleCell : UITableViewCell

//收到的红包
- (void)TVConfigIncomeCell:(MKRedListModel *)inModel;
- (void)RMBConfigIncomeCell:(MKRedListModel *)inModel;
//发出的红包
- (void)TVConfigOutcomeCell:(MKRedPaymodel *)inModel;
- (void)RMBConfigOutcomeCell:(MKRedPaymodel *)inModel;
@end
