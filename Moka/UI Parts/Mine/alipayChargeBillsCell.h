//
//  alipayChargeBillsCell.h
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "alipayChargeBillModel.h"

@interface alipayChargeBillsCell : UITableViewCell

//来源
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//时间
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
//金额
@property (strong, nonatomic) IBOutlet UILabel *crashLabel;
//状态
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic,strong) alipayChargeBillModel * model;

@end
