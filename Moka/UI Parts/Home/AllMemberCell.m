//
//  AllMemberCell.m
//  Moka
//
//  Created by btc123 on 2017/11/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "AllMemberCell.h"

@implementation AllMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.membersImage.layer.cornerRadius = self.membersImage.size.width/2.0;
    self.membersImage.layer.masksToBounds = YES;
    self.VIPImageView.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setMemberModel:(MKCircleMemberModel *)memberModel{
    _memberModel = memberModel;
    
    //头像
    [self.membersImage openImage:_memberModel.img];
    //
    if (memberModel.ifhave == 1) {
        self.VIPImageView.hidden = NO;
    }else{
        self.VIPImageView.hidden = YES;
    }
    //名字
    self.membersNameLabel.text = _memberModel.name;
}

@end
