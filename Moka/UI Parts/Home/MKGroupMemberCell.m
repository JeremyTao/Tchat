//
//  MKGroupMemberCell.m
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKGroupMemberCell.h"

@interface MKGroupMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *VIPImageView;


@end

@implementation MKGroupMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.VIPImageView.hidden = YES;
}
- (void)configCellWith:(MKCircleMemberModel *)model {
    [_headImgView setImageUPSUrl:model.img];
    if (model.ifhave == 1) {
        self.VIPImageView.hidden = NO;
    }else{
        self.VIPImageView.hidden = YES;
    }
    //
    _nameLabel.text = model.name;
    _ageLabel.text  = [NSString stringWithFormat:@"%ld", (long)model.age];
    if (model.sex == 1) {
        _genderImageView.image = IMAGE(@"near_female");
    } else if (model.sex == 2) {
        _genderImageView.image = IMAGE(@"near_male");
    } else {
        _genderImageView.image = nil;
    }
}

- (void)configCellWithPeopleModel:(MKPeopleModel *)pModel {
    [_headImgView setImageUPSUrl:pModel.img];
    if (pModel.ifhave == 1) {
        self.VIPImageView.hidden = NO;
    }else{
        self.VIPImageView.hidden = YES;
    }
    _nameLabel.text = pModel.name;
    _ageLabel.text  = [NSString stringWithFormat:@"%ld", (long)pModel.age];
    if (pModel.sex == 1) {
        _genderImageView.image = IMAGE(@"near_female");
    } else if (pModel.sex == 2) {
        _genderImageView.image = IMAGE(@"near_male");
    } else {
        _genderImageView.image = nil;
    }
}
@end
