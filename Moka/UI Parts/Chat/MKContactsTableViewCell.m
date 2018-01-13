//
//  MKContactsTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKContactsTableViewCell.h"

@interface MKContactsTableViewCell ()

{
    PPPersonModel *myPersonModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;

@end

@implementation MKContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)configWith:(PPPersonModel *)contact withIndexpath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    myPersonModel = contact;
    _phoneLabel.text = contact.mobileArray.firstObject;
    _userNameLabel.text = contact.name;
    _userImageView.image = contact.headerImage ? contact.headerImage : [UIImage imageNamed:@"chat_default_avatar"];
    if (contact.invited == 0) {
        [_operationButton setTitle:@"添加" forState:UIControlStateNormal];
        _operationButton.backgroundColor = commonBlueColor;
    } else {
        [_operationButton setTitle:@"已邀请" forState:UIControlStateNormal];
        _operationButton.backgroundColor = RGB_COLOR_HEX(0x51CA6C);
    }
    
}

- (IBAction)operationButtonClicked:(UIButton *)sender {
       if (self.delegate && [self.delegate respondsToSelector:@selector(inviteFriendWithPerson:)]) {
        [self.delegate inviteFriendWithPerson:myPersonModel];
    }
}


@end
