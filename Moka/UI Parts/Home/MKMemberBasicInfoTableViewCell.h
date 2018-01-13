//
//  MKMemberBasicInfoTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/7.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPeopleRootModel.h"
#import "SDCycleScrollView.h"

@protocol MKMemberBasicInfoTableViewCellDelegate <NSObject>

- (void)openFansController;
- (void)openFollowersController;

@end

@interface MKMemberBasicInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MKMemberBasicInfoTableViewCellDelegate> delegate;

- (void)configCycleScrollViewWithImageUrls:(NSArray *)imageUrls delegate:(id<SDCycleScrollViewDelegate>)delegate;
- (void)comfigUserBasicInfoWith:(MKPeopleRootModel *)userModel;

//- (void)setOffset:(CGFloat)offset;

@end
