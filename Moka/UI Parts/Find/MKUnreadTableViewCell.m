//
//  MKUnreadTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKUnreadTableViewCell.h"

@interface MKUnreadTableViewCell ()

{
    MKUnreadMessageModel *unreadModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dynamicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImgVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicImgWitdth;
@property (strong, nonatomic) IBOutlet UIImageView *VIPImageView;



@end

@implementation MKUnreadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.VIPImageView.hidden = YES;
}

- (void)configCell:(MKUnreadMessageModel *)model {
    unreadModel = model;
    [_userHeadImageView setImageUPSUrl:model.img];
    //
    if (model.ifhave == 1) {
        self.VIPImageView.hidden = NO;
    }else{
        self.VIPImageView.hidden = YES;
    }
    //
    _nameLabel.text = model.replyName;
    _dateLabel.text = model.createtime;
    if (model.ifdel == 1) {
        //评论
        _likeImgVIew.hidden = YES;
        _contentLabel.text = model.commenttext;
    } else if (model.ifdel == 2) {
        //点赞
        _likeImgVIew.hidden = NO;
        _contentLabel.text = @"";
    } else if (model.ifdel == 3) {
        //打赏
        _likeImgVIew.hidden = YES;
        _contentLabel.text = AppendStrings(model.replyName,@"打赏了你");
    }
    
    if (model.messageimg.length > 0) {
        [_dynamicImageView setImageUPSUrl:model.messageimg];
        _dynamicImgWitdth.constant = 60;
    } else {
        _dynamicImgWitdth.constant = 0;
    }
}

@end
