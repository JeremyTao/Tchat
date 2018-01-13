//
//  AllMemberCell.h
//  Moka
//
//  Created by btc123 on 2017/11/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCircleMemberModel.h"

@interface AllMemberCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *membersImage;
@property (strong, nonatomic) IBOutlet UILabel *membersNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *VIPImageView;


@property (nonatomic,strong) MKCircleMemberModel * memberModel;
@end
