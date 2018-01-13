//
//  MKTagsTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKInterestTagModel.h"

@interface MKTagsTableViewCell : UITableViewCell

- (void)configCell:(MKInterestTagModel *)model;
- (void)configSingleSelectCell:(MKInterestTagModel *)model;


@end
