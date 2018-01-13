//
//  MKGroupMemberCell.h
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCircleMemberModel.h"
#import "MKPeopleModel.h"

@interface MKGroupMemberCell : UITableViewCell

- (void)configCellWith:(MKCircleMemberModel *)model;

- (void)configCellWithPeopleModel:(MKPeopleModel *)pModel;

@end
