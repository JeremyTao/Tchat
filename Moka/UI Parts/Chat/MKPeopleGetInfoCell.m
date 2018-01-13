//
//  MKPeopleGetInfoCell.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKPeopleGetInfoCell.h"

@interface MKPeopleGetInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *bestLuckLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bestLuckImageView;


@end

@implementation MKPeopleGetInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

//个人
- (void)configCellWith:(MKPeopleGetMoneyModel *)model {
    [_headImageView setImageUPSUrl:model.img];
    _userNameLabel.text = model.name;
    //
    _timeLabel.text = [NSString stringWithFormat:@"%@",[self changeToTime:[model.time integerValue]]];
    
    if (model.coinType == 1) {
        //RMB
        _moneyLabel.text = [NSString stringWithFormat:@"%.2f元", [model.money floatValue]];
    }else{
        _moneyLabel.text = [NSString stringWithFormat:@"%@TV", [NSString removeFloatAllZero:([model.money doubleValue] / 1000.0)]];
    }
    
    _bestLuckLabel.hidden = YES;
    _bestLuckImageView.hidden = YES;
//    if (model.bestLuck == 0) {
//        _bestLuckLabel.hidden = YES;
//        _bestLuckImageView.hidden = YES;
//    } else {
//        _bestLuckLabel.hidden = NO;
//        _bestLuckImageView.hidden = NO;
//    }
}

#pragma mark -- 群
-(void)RMBConfigGroupRedWith:(GroupGetModel *)model bestLuck:(BOOL)luck{
    
    [_headImageView setImageUPSUrl:model.portrail];
    _userNameLabel.text = model.name;
    _timeLabel.text = [NSString stringWithFormat:@"%@",[self changeToTime:model.time]];
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[model.money floatValue]];
    if (luck) {
        _bestLuckLabel.hidden = NO;
        _bestLuckImageView.hidden = NO;
    } else {
        _bestLuckLabel.hidden = YES;
        _bestLuckImageView.hidden = YES;
    }
}

-(void)TVConfigGroupRedWith:(GroupGetModel *)model bestLuck:(BOOL)luck{
    
    [_headImageView setImageUPSUrl:model.portrail];
    _userNameLabel.text = model.name;
    _timeLabel.text = [NSString stringWithFormat:@"%@",[self changeToTime:model.time]];
    _moneyLabel.text = [NSString stringWithFormat:@"%@TV", [NSString removeFloatAllZero:([model.money  doubleValue]/ 1000.0)]];
    if (luck) {
        _bestLuckLabel.hidden = NO;
        _bestLuckImageView.hidden = NO;
    } else {
        _bestLuckLabel.hidden = YES;
        _bestLuckImageView.hidden = YES;
    }
}



-(void)configGroupRedWith:(GroupGetModel *)model bestLuck:(BOOL)luck coinType:(NSString *)type{
    
    [_headImageView setImageUPSUrl:model.portrail];
    _userNameLabel.text = model.name;
    _timeLabel.text = [NSString stringWithFormat:@"%@",[self changeToTime:model.time]];
    if ([type isEqualToString:@"1"]) {
        
        _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[model.money floatValue]];
    }else{
        
        _moneyLabel.text = [NSString stringWithFormat:@"%@TV", [NSString removeFloatAllZero:([model.money  doubleValue]/ 1000.0)]];
    }
    if (luck) {
        _bestLuckLabel.hidden = NO;
        _bestLuckImageView.hidden = NO;
    } else {
        _bestLuckLabel.hidden = YES;
        _bestLuckImageView.hidden = YES;
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
