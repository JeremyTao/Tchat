//
//  MKUnreadTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKUnreadMessageModel.h"


@interface MKUnreadTableViewCell : UITableViewCell

- (void)configCell:(MKUnreadMessageModel *)model;

@end
