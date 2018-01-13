//
//  MKPeopleListTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPeopleListModel.h"

@interface MKPeopleListTableViewCell : UITableViewCell

- (void)configCellWith:(MKPeopleListModel *)model;

@end
