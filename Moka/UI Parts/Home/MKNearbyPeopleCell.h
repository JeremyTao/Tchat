//
//  MKNearbyPeopleCell.h
//  Moka
//
//  Created by Knight on 2017/7/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNearbyPeopleModel.h"
#import "MKCircleMemberModel.h"
#import "MKOnlineModel.h"

@interface MKNearbyPeopleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (assign, nonatomic) BOOL smallSize;

- (void)configNearbyCellWith:(MKNearbyPeopleModel *)nearbyModel;
- (void)configMemberCellWith:(MKCircleMemberModel *)memberModel;
- (void)configAddMemberCell;
- (void)configOnlinePeopleWith:(MKOnlineModel *)onlineModel;
- (void)configAddMemberCellWith:(MKCircleMemberModel *)addModel;

@end
