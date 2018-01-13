//
//  MKTotalInfoCell.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKTotalInfoCell.h"

@interface MKTotalInfoCell ()
{
    MKInOutRedPacketModel *myModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCoinsLabel;
//发出的红包
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//收到的红包
@property (strong, nonatomic) IBOutlet UILabel *getRedLabel;
@property (strong, nonatomic) IBOutlet UILabel *getNoticeLabel;
//手气最佳
@property (strong, nonatomic) IBOutlet UILabel *luckLabel;
@property (strong, nonatomic) IBOutlet UILabel *luckNoticeLabel;


@end



@implementation MKTotalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.totalCoinsLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark -- 收到的红包
-(void)TVConfigTotalInfoWith:(MKInOutRedPacketModel *)model{
    
    //头像
    NSString * imgs = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userImageStr"];
    [_userHeadImageView setImageUPSUrl:imgs];
    //姓名
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    _userNameLabel.text = [NSString stringWithFormat:@"%@共收到",name];
    //
    _countLabel.hidden = YES;
    //金额
    NSString *moneyString = [NSString stringWithFormat:@"%@ TV", [NSString removeFloatAllZero:[model.allmoney doubleValue] / 1000.0]];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:moneyString attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:50],NSForegroundColorAttributeName: RedPacketColor}];
    
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(moneyString.length - 3, 3)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x2A2A2A) range:NSMakeRange(moneyString.length - 3, 3)];
    _totalCoinsLabel.attributedText = attributedStr;
    
    //
    _getRedLabel.text = [NSString stringWithFormat:@"%@",model.redSize ? model.redSize : @"0"];
    _getRedLabel.hidden = NO;
    _getNoticeLabel.hidden = NO;
    //手气最佳
    _luckLabel.text = [NSString stringWithFormat:@"%@",model.luckcount];
    _luckLabel.hidden = NO;
    _luckNoticeLabel.hidden = NO;

}

-(void)RMBConfigTotalInfoWith:(MKInOutRedPacketModel *)model{
    //头像
    NSString * imgs = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userImageStr"];
    [_userHeadImageView setImageUPSUrl:imgs];
    //姓名
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    _userNameLabel.text = [NSString stringWithFormat:@"%@共收到",name];
    //
    _countLabel.hidden = YES;
    //金额
    NSString *moneyString = [NSString stringWithFormat:@"¥%.2f",[model.allmoney floatValue]];
    _totalCoinsLabel.text = moneyString;
    //
    _getRedLabel.text = [NSString stringWithFormat:@"%@",model.redSize];
    _getRedLabel.hidden = NO;
    _getNoticeLabel.hidden = NO;
    //手气最佳
    _luckLabel.text = [NSString stringWithFormat:@"%@",model.luckcount];
    _luckLabel.hidden = NO;
    _luckNoticeLabel.hidden = NO;
}


#pragma mark -- 发出去的红包
-(void)TVConfigTotalOutInfoWith:(MKPayRedPacketModel *)model{
    
    //头像
    NSString * imgs = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userImageStr"];
    [_userHeadImageView setImageUPSUrl:imgs];
    //姓名
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    _userNameLabel.text = [NSString stringWithFormat:@"%@共发出",name];
    //
    _countLabel.hidden = NO;
    _countLabel.text = [NSString stringWithFormat:@"发出红包%@个",model.redSize];
    //金额
    NSString *moneyString = [NSString stringWithFormat:@"%@ TV", [NSString removeFloatAllZero:[model.allmoney doubleValue] / 1000.0]];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:moneyString attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:50],NSForegroundColorAttributeName: RedPacketColor}];
    
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(moneyString.length - 3, 3)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x2A2A2A) range:NSMakeRange(moneyString.length - 3, 3)];
    _totalCoinsLabel.attributedText = attributedStr;
    
    //收到的红包
    _getRedLabel.hidden = YES;
    _getNoticeLabel.hidden = YES;
    //手气最佳
    _luckLabel.hidden = YES;
    _luckNoticeLabel.hidden = YES;
    
}
-(void)RMBConfigTotalOutInfoWith:(MKPayRedPacketModel *)model{
    
    //头像
    NSString * imgs = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.userImageStr"];
    [_userHeadImageView setImageUPSUrl:imgs];
    //姓名
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo.name"];
    _userNameLabel.text = [NSString stringWithFormat:@"%@共发出",name];
    //
    _countLabel.hidden = NO;
    _countLabel.text = [NSString stringWithFormat:@"发出红包%@个",model.redSize];
    //金额
    NSString *moneyString = [NSString stringWithFormat:@"¥%.2f",[model.allmoney doubleValue]];
    _totalCoinsLabel.text = moneyString;
    //收到的红包
    _getRedLabel.hidden = YES;
    _getNoticeLabel.hidden = YES;
    //手气最佳
    _luckLabel.hidden = YES;
    _luckNoticeLabel.hidden = YES;
    
}


@end
