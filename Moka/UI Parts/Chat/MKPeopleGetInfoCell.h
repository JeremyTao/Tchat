//
//  MKPeopleGetInfoCell.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKPeopleGetMoneyModel.h"
#import "MKGroupRedGetModel.h"
#import "GroupGetModel.h"

@interface MKPeopleGetInfoCell : UITableViewCell

- (void)configCellWith:(MKPeopleGetMoneyModel *)model;

//群红包
- (void)configGroupRedWith:(GroupGetModel *)model bestLuck:(BOOL)luck coinType:(NSString *)type;
//- (void)RMBConfigGroupRedWith:(GroupGetModel *)model bestLuck:(BOOL)luck;

@end
