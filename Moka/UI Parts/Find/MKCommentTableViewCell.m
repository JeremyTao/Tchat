//
//  MKCommentTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKCommentTableViewCell.h"

@interface MKCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMaginConstraint;


@end

@implementation MKCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCell:(MKDynamicCommentModel *)model {
    
    [_userHeadImage setImageUPSUrl:model.img];
    _userNameLabel.text = model.name;
    _dateLabel.text = [NSString compareCurrentTime:model.createtime];
    
    if (model.replycomid == 0) {
        //第一级评论
        _contentLabel.text = model.commenttext;
        _leftMaginConstraint.constant = 25;
    } else {
        //不是第一级
        _contentLabel.text = [NSString stringWithFormat:@"回复%@ : %@",model.replyName, model.commenttext];
        _leftMaginConstraint.constant = 77;
    }
    
    if (model.hideSeperatorLine) {
        _seperatorLine.hidden = YES;
    } else {
        _seperatorLine.hidden = NO;
    }
    
    
}
@end
