//
//  MKIncomePeopleCell.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKIncomePeopleCell.h"

@interface MKIncomePeopleCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckLabel;


@end

@implementation MKIncomePeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark -- 收到的红包
#pragma mark -- TV
-(void)TVConfigIncomeCell:(MKRedListModel *)inModel{
    
    //名字
    if ([inModel.repkUserName isEqualToString:@""]) {
        _nameLabel.text = inModel.name;
    }else{
        _nameLabel.text = inModel.repkUserName;
    }
    //时间
    _timeLabel.text = [self changeToTime:inModel.endtime];
    _moneyLabel.text = [NSString stringWithFormat:@"%@ TV", [NSString removeFloatAllZero:[inModel.money doubleValue] / 1000.0]];
    _statusLabel.text = @"";
    if (inModel.count == 2) {
        _luckLabel.hidden = NO;
        _nameLabel.text = @"拼手气红包";
    }else{
        _luckLabel.hidden = YES;
        _nameLabel.text = @"普通红包";
    }
}

//RMB
-(void)RMBConfigIncomeCell:(MKRedListModel *)inModel{
    
    //名字
    if ([inModel.repkUserName isEqualToString:@""]) {
        _nameLabel.text = inModel.name;
    }else{
        _nameLabel.text = inModel.repkUserName;
    }
    //时间
    _timeLabel.text = [self changeToTime:inModel.endtime];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[inModel.money floatValue]];
    _statusLabel.text = @"";
    if (inModel.count == 2) {
        _luckLabel.hidden = NO;
        _nameLabel.text = @"拼手气红包";
    }else{
        _luckLabel.hidden = YES;
        _nameLabel.text = @"普通红包";
    }
}


#pragma mark -- 发出的红包
-(void)TVConfigOutcomeCell:(MKRedPaymodel *)inModel{
    
    if (inModel.count == 2) {
        _luckLabel.hidden = NO;
        _nameLabel.text = @"拼手气红包";
    } else {
        _luckLabel.hidden = YES;
        _nameLabel.text = @"普通红包";
    }
    //
    _timeLabel.text = [self changeToTime:inModel.createtime];
    _moneyLabel.text = [NSString stringWithFormat:@"%@ TV", [NSString removeFloatAllZero:[inModel.totalMoney doubleValue] / 1000.0]];
    if (inModel.state == 0) {
        _statusLabel.text = @"";
    } else if (inModel.state == 1) {
        _statusLabel.text = @"";
    } else if (inModel.state == 2) {
        _statusLabel.text = @"";
    }
}

-(void)RMBConfigOutcomeCell:(MKRedPaymodel *)inModel{
    
    if (inModel.count == 2) {
        _luckLabel.hidden = NO;
        _nameLabel.text = @"拼手气红包";
    } else {
        _luckLabel.hidden = YES;
        _nameLabel.text = @"普通红包";
    }
    //
    _timeLabel.text = [self changeToTime:inModel.createtime];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", [inModel.totalMoney floatValue]];
    if (inModel.state == 0) {
        _statusLabel.text = @"";
    } else if (inModel.state == 1) {
        _statusLabel.text = @"";
    } else if (inModel.state == 2) {
        _statusLabel.text = @"";
    }
}




-(NSString *)changeToTime:(NSInteger)timeStr{
    
    NSString *timeStampString = [NSString stringWithFormat:@"%ld",(long)timeStr];
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    
    return dateString;
}


@end
