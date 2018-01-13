//
//  MKInviteTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/2.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKInviteTableViewCell.h"

@interface MKInviteTableViewCell ()

{
    MKPeopleModel *myModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (strong, nonatomic) IBOutlet UIImageView *VIPImageView;

@end

@implementation MKInviteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.VIPImageView.hidden = YES;
}

- (void)configCellWith:(MKPeopleModel *)model {
    myModel = model;
    [_userHeadImageView setImageUPSUrl:model.img];
    if (model.ifhave == 1) {
        self.VIPImageView.hidden = NO;
    }else{
        self.VIPImageView.hidden = YES;
    }
    //
    _nameLabel.text = model.name;
    _ageLabel.text = [NSString stringWithFormat:@"%ld", model.age];
  
    
    if (model.sex == 1) {
        _genderImage.image = IMAGE(@"near_female");
    } else if (model.sex == 2) {
        _genderImage.image = IMAGE(@"near_male");
    } else {
        _genderImage.image = nil;
    }
    
    if (model.select) {
        _circleImageView.image = IMAGE(@"near_circle_choose");
    } else {
        _circleImageView.image = IMAGE(@"near_circle1");
    }
    
}

- (IBAction)selectButtonClickde:(UIButton *)sender {
    if (myModel.select) {
        _circleImageView.image = IMAGE(@"near_circle1");
        myModel.select = 0;
    } else {
        _circleImageView.image = IMAGE(@"near_circle_choose");
        myModel.select = 1;
    }
    
}

- (IBAction)headButtonClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedUserHeadImageWithID:)]) {
        [self.delegate didClickedUserHeadImageWithID:[NSString stringWithFormat:@"%ld", myModel.coveruserid]];
    }
    
}


@end
