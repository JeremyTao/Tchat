//
//  MKNearbyPeopleCell.m
//  Moka
//
//  Created by Knight on 2017/7/20.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKNearbyPeopleCell.h"

@interface MKNearbyPeopleCell ()

{
    MKNearbyPeopleModel *myModel;
    MKCircleMemberModel *myMemberModel;
    MKOnlineModel       *myOnlineModel;
}


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@property (weak, nonatomic) IBOutlet UIImageView *expertImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertImageViewRightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *followButton;


@end

@implementation MKNearbyPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headImageView.layer.cornerRadius =  _imageWidth.constant / 2.0;
    _headImageView.layer.masksToBounds = YES;
    
    if (iPhone5) {
        _imageWidth.constant = 70;
        _headImageView.layer.cornerRadius =  _imageWidth.constant / 2.0;

    }
}

- (void)setSmallSize:(BOOL)smallSize {
    if (smallSize) {
        _imageWidth.constant = SCREEN_WIDTH / 6.0;
        _headImageView.layer.cornerRadius =  _imageWidth.constant / 2.0;
        
        _expertViewWidth.constant = 20;
        _expertImageViewRightConstraint.constant = 0;
    }
}

- (void)configNearbyCellWith:(MKNearbyPeopleModel *)nearbyModel {
    _headImageView.image = nil;
    myModel = nearbyModel;
    _nameLabel.text = nearbyModel.name;
//    [_headImageView openImage:nearbyModel.portrail];
    [_headImageView setImageUPSUrl:nearbyModel.portrail];
    if (nearbyModel.ifhave) {
        _expertImageView.hidden = NO;
    } else {
        _expertImageView.hidden = YES;
    }
    
    if (nearbyModel.ifFollow == 0) {
        _followButton.titleLabel.text = @"+关注";
        [_followButton setTitle:@"+关注" forState:UIControlStateNormal];
        _followButton.backgroundColor = commonBlueColor;
    } else {
        _followButton.titleLabel.text = @"已关注";
        [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
        _followButton.backgroundColor = RGB_COLOR_HEX(0xCCCCCC);
    }
}

- (void)configMemberCellWith:(MKCircleMemberModel *)memberModel {
    _headImageView.image = nil;
    myMemberModel = memberModel;
    _nameLabel.text = memberModel.name;
    [_headImageView setImageUPSUrl:memberModel.img];
    
    if (memberModel.ifhave) {
        _expertImageView.hidden = NO;
    } else {
        _expertImageView.hidden = YES;
    }
    
}

- (void)configAddMemberCellWith:(MKCircleMemberModel *)addModel {
    _headImageView.image = IMAGE(@"near_add_member");
    _nameLabel.text = @"添加";
    _headImageView.image = IMAGE(@"near_add_member");
    _expertImageView.hidden = YES;
}

- (void)configOnlinePeopleWith:(MKOnlineModel *)onlineModel {
    myOnlineModel = onlineModel;
    _nameLabel.text = onlineModel.name;
    _headImageView.image = nil;
    [_headImageView setImageUPSUrl:onlineModel.img];
    if (onlineModel.ifhave) {
        _expertImageView.hidden = NO;
    } else {
        _expertImageView.hidden = YES;
    }
}
- (IBAction)followButtonClicked:(UIButton *)sender {
    if (myModel.ifFollow == 1) {
        //取消follow
        [self requestUnFollowUser];
    } else {
        
        [self requestFollowUser];
    }
}


#pragma mark - HTTP  ➕关注

- (void)requestFollowUser {
    NSDictionary *paramDitc = @{@"coveruserid" : @(myModel.id)};
    
    
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_follow_user] params:paramDitc success:^(id json) {
        
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"➕关注 %@",json);
        
        
        if (status == 200) {
            myModel.ifFollow = 1;
            _followButton.titleLabel.text = @"已关注";
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            _followButton.backgroundColor = RGB_COLOR_HEX(0xCCCCCC);
            [MKUtilHUD showAutoHiddenTextHUD:@"关注成功" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
            
        }
        
    } failure:^(NSError *error) {
      
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
        DLog(@"%@",error);
    }];
}

#pragma mark - HTTP  取消关注

- (void)requestUnFollowUser {
    NSDictionary *paramDitc = @{@"coveruserid" : @(myModel.id)};
    
    
    [[MKNetworkManager sharedManager] post:[NSString stringWithFormat:@"%@%@",WAP_URL, api_unfollow_user] params:paramDitc success:^(id json) {
        
        NSInteger status = [[json objectForKey:@"status"] integerValue];
        NSString  *message = json[@"exception"];
        DLog(@"取消关注 %@",json);
        
        if (status == 200) {
            myModel.ifFollow = 0;
            _followButton.titleLabel.text = @"+关注";
            [_followButton setTitle:@"+关注" forState:UIControlStateNormal];
            _followButton.backgroundColor = commonBlueColor;
            [MKUtilHUD showAutoHiddenTextHUD:@"取消关注成功" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
            
        } else {
            [MKUtilHUD showAutoHiddenTextHUD:message withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
        }
        
    } failure:^(NSError *error) {
        
        [MKUtilHUD showAutoHiddenTextHUD:@"网络请求失败" withSecond:2 inView:[UIApplication sharedApplication].keyWindow];
        DLog(@"%@",error);
    }];
}




@end
