//
//  MKPeopleListTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKPeopleListTableViewCell.h"

@interface MKPeopleListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userheadImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *VIPImageView;


@end

@implementation MKPeopleListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.VIPImageView.hidden = YES;
}


- (void)configCellWith:(MKPeopleListModel *)model {
    [_userheadImage setImageUPSUrl:model.img];
    if (model.ifhave == 1) {
        self.VIPImageView.hidden = NO;
    }else{
        self.VIPImageView.hidden = YES;
    }
    //
    _userNameLabel.text = model.name;
    _contentLabel.text = model.remark;
    _ageLabel.text = [NSString stringWithFormat:@"%ld", model.age];
    _loginTimeLabel.text = [NSString compareCurrentTime:model.createtime];
    
    if (model.sex == 1) {
        _genderImageView.image = IMAGE(@"near_female");
    } else if (model.sex == 2) {
        _genderImageView.image = IMAGE(@"near_male");
    } else {
        _genderImageView.image = nil;
    }
}
@end
