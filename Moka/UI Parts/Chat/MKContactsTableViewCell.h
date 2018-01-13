//
//  MKContactsTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPersonModel.h"

@protocol MKContactsTableViewCellDelegate <NSObject>

- (void)inviteFriendWithPerson:(PPPersonModel *)model;

@end

@interface MKContactsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MKContactsTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWith:(PPPersonModel *)contact withIndexpath:(NSIndexPath *)indexPath;

@end
