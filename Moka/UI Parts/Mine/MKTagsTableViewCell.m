//
//  MKTagsTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKTagsTableViewCell.h"

@interface MKTagsTableViewCell ()

{
    MKInterestTagModel *myModel;
}

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation MKTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCell:(MKInterestTagModel *)model {
    myModel = model;
    _tagLabel.text = model.name;
    if (model.selected) {
        _selectImgView.image = IMAGE(@"choose");
        _tagLabel.font = [UIFont fontWithName:@"System" size:16];
    } else {
        _selectImgView.image = nil;
        _tagLabel.font = [UIFont fontWithName:@"System Thin" size:16];
    }
}

- (void)configSingleSelectCell:(MKInterestTagModel *)model {
    [_selectButton removeFromSuperview];
    myModel = model;
    _tagLabel.text = model.name;
    if (model.selected) {
        _selectImgView.image = IMAGE(@"choose");
        _tagLabel.font = [UIFont fontWithName:@"System" size:16];
    } else {
        _selectImgView.image = nil;
        _tagLabel.font = [UIFont fontWithName:@"System Thin" size:16];
    }
}





- (IBAction)buttonEvent:(UIButton *)sender {
    if (!myModel.selected) {
        _selectImgView.image = IMAGE(@"choose");
        myModel.selected = 1;
        _tagLabel.font = [UIFont fontWithName:@"System" size:16];
    } else {
        _selectImgView.image = nil;
        myModel.selected = 0;
        _tagLabel.font = [UIFont fontWithName:@"System Thin" size:16];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
