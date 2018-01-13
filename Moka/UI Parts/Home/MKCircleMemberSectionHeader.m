//
//  MKCircleMemberSectionHeader.m
//  Moka
//
//  Created by  moka on 2017/8/7.
//  Copyright © 2017年 moka. All rights reserved.
//
#define highLight_color  RGB_COLOR_HEX(0x2A2A2A)
#define normal_color     RGB_COLOR_HEX(0xB3B3B3)

#import "MKCircleMemberSectionHeader.h"

@interface MKCircleMemberSectionHeader ()


@property (weak, nonatomic) IBOutlet UIButton *userInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *baseView;



@end


@implementation MKCircleMemberSectionHeader


- (void)awakeFromNib {
    [super awakeFromNib];
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_baseView.mas_bottom).offset(0);
        make.centerX.equalTo(_userInfoButton.mas_centerX).offset(0);
        make.width.equalTo(@(74));
        make.height.equalTo(@(2));
    }];
    
}


- (IBAction)userInfoButtonClicked:(UIButton *)sender {
    [_userInfoButton setTitleColor:highLight_color forState:UIControlStateNormal];
    [_dynamicButton setTitleColor:normal_color forState:UIControlStateNormal];
    [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_baseView.mas_bottom).offset(0);
        make.centerX.equalTo(_userInfoButton.mas_centerX).offset(0);
        make.width.equalTo(@(74));
        make.height.equalTo(@(2));
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedUserInfoButton)]) {
        [self.delegate didClickedUserInfoButton];
    }
}

- (IBAction)dynamicButtonClicked:(UIButton *)sender {
    [_userInfoButton setTitleColor:normal_color forState:UIControlStateNormal];
    [_dynamicButton setTitleColor:highLight_color forState:UIControlStateNormal];
    
    [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_baseView.mas_bottom).offset(0);
        make.centerX.equalTo(_dynamicButton.mas_centerX).offset(0);
        make.width.equalTo(@(38));
        make.height.equalTo(@(2));
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedDynamicButton)]) {
        [self.delegate didClickedDynamicButton];
    }
}


@end
