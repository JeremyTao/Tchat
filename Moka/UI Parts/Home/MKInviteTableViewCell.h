//
//  MKInviteTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/2.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPeopleModel.h"

@protocol MKInviteTableViewCellDelegate <NSObject>

- (void)didClickedUserHeadImageWithID:(NSString *)userId;


@end

@interface MKInviteTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MKInviteTableViewCellDelegate> delegate;

- (void)configCellWith:(MKPeopleModel *)model;

@end
