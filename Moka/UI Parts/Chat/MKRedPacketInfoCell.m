//
//  MKRedPacketInfoCell.m
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#define SenderHintWaitOpen  @"等待对方领取"
#define SenderHintOpened    @"对方已领取"
#define ReciverHintOpend    @"已存入我的钛值，可用于发红包"
#define ReciverChargeOpend  @"已存入我的零钱，可用于发红包"
#define SenderSubHint       @"未领取的红包，将于24小时后退还"
#define EmptyHint           @""
#define PastDue             @"该红包已过期"
#define RobOut              @"手慢了，红包已抢完"
#define SelfRobOut          @"红包已抢完"

#import "MKRedPacketInfoCell.h"

@interface MKRedPacketInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *senderImageView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *redPacketTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckMarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mianHintLabel;

@property (weak, nonatomic) IBOutlet UILabel *subHintLabel;//已存入我的钱包，可用于发红包
@property (strong, nonatomic) IBOutlet UIView *redNoticeView;
@property (strong, nonatomic) IBOutlet UILabel *redNoticeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *redViewHeight;



@end

@implementation MKRedPacketInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configGroupRedWith:(NewGroupDetailModel *)groupRedModel{
    
    _redNoticeView.hidden = YES;
    _redNoticeLabel.hidden = YES;
    _redViewHeight.constant = 0;
    _luckMarkLabel.hidden = YES;
    //发送人的头像
    [_senderImageView setImageUPSUrl:groupRedModel.sendUser.portrail];
    _senderNameLabel.text = [NSString stringWithFormat:@"%@的红包", groupRedModel.sendUser.name];
    _redPacketTitleLabel.text = groupRedModel.remark;
    
    if (groupRedModel.cointype == 1) {
        //RMB
        //金额
        NSString *totalCoinsString =  [NSString stringWithFormat:@"%@ 元",groupRedModel.totalMoney];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalCoinsString attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:50], NSForegroundColorAttributeName: RedPacketColor}];
        
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(totalCoinsString.length - 2, 2)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x4A4A4A) range:NSMakeRange(totalCoinsString.length - 2, 2)];
        
        _totalCoinsLabel.attributedText = attributedStr;
    }else{
        //金额
        NSString *totalCoinsString =  [NSString stringWithFormat:@"%@ TV",[NSString removeFloatAllZero:([groupRedModel.totalMoney doubleValue] / 1000.0)]];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalCoinsString attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:50], NSForegroundColorAttributeName: RedPacketColor}];
        
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(totalCoinsString.length - 3, 3)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x4A4A4A) range:NSMakeRange(totalCoinsString.length - 3, 3)];
        
        _totalCoinsLabel.attributedText = attributedStr;
    }
    
    //红包状态
    if (groupRedModel.state == 0) {
        //显示为未领取(仅sender)
        _mianHintLabel.text = SenderHintWaitOpen;
        _subHintLabel.text = SenderSubHint;
        
    } else if (groupRedModel.state == 1) {
        
        //判读是不是自己在查看
        if (groupRedModel.sendUser.id == [[MKChatTool sharedChatTool].currentUserInfo.userId integerValue]) {
            //自己是发送人
            _mianHintLabel.text = SenderHintOpened;
            _subHintLabel.text = EmptyHint;
            
        }
        
        for (int i = 0; i < groupRedModel.receiveUserList.count; i ++) {
            GroupGetModel *model = groupRedModel.receiveUserList[i];
            if (model.id == [[MKChatTool sharedChatTool].currentUserInfo.userId integerValue]) {
                //自己是接受方
                _mianHintLabel.text = EmptyHint;
                if (groupRedModel.cointype == 1) {
                    _subHintLabel.text = ReciverChargeOpend;
                }else{
                    _subHintLabel.text = ReciverHintOpend;
                }
                
            }
        }
        
        
    } else if (groupRedModel.state == 2) {
        
        _mianHintLabel.text = PastDue;
        if (groupRedModel.cointype == 1) {
            //RMB
            _subHintLabel.text  = [NSString stringWithFormat:@"已领取0/1个，共0.00/%@元",groupRedModel.totalMoney];
        }else{
            _subHintLabel.text  = [NSString stringWithFormat:@"已领取0/1个，共0.00/%@TV",[NSString removeFloatAllZero:([groupRedModel.totalMoney doubleValue] / 1000.0)]];
        }
        
    }
}







#pragma mark -- RMB
-(void)RMBConfigGroupRedWith:(NewGroupDetailModel *)groupRedModel{
    
    _redNoticeView.hidden = NO;
    _redNoticeLabel.hidden = NO;
    _redViewHeight.constant = 29;
    _redPacketTitleLabel.text = groupRedModel.remark;
    //拼手气红包??
    if (groupRedModel.count == 2) {
        _luckMarkLabel.hidden = NO;
    } else {
        _luckMarkLabel.hidden = YES;
    }
    //发送人info
    [_senderImageView setImageUPSUrl:groupRedModel.sendUser.portrail];
    _senderNameLabel.text = [NSString stringWithFormat:@"%@的红包", groupRedModel.sendUser.name];
    
    for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
        
        if (sendUser.id == [[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"] integerValue]) {
            
            //金额
            NSString *totalCoinsString =  [NSString stringWithFormat:@"%.2f 元",[sendUser.money floatValue]];
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalCoinsString attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:50], NSForegroundColorAttributeName: RedPacketColor}];
            
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(totalCoinsString.length - 2, 2)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x4A4A4A) range:NSMakeRange(totalCoinsString.length - 2, 2)];
            
            _totalCoinsLabel.attributedText = attributedStr;
            
        }else{
            
            
            _totalCoinsLabel.text = @" ";
        }
    }
    
    _mianHintLabel.text = EmptyHint;
    _subHintLabel.text = ReciverChargeOpend;
    //计算已抢到的金额
    float sum = 0;
    for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
        
        sum = [sendUser.money floatValue] + sum;
    }
    //
    _redNoticeLabel.text = [NSString stringWithFormat:@"已领取%d/%d个,共%.2f/%.2f元",groupRedModel.snatchedCount,groupRedModel.redpkCount,sum,[groupRedModel.totalMoney floatValue]];

    //红包状态，0:未领取, 1:已领取，2:已过期，3-已抢完
    if (groupRedModel.state == 2) {
        _mianHintLabel.text = PastDue;
        _subHintLabel.text  = EmptyHint;
        _totalCoinsLabel.hidden = YES;
        //已抢的金额
        float sum = 0;
        for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
            
            sum = [sendUser.money floatValue] + sum;
        }
        _redNoticeLabel.text = [NSString stringWithFormat:@"已领取%d/%d个,共%.2f/%.2f元",groupRedModel.snatchedCount,groupRedModel.redpkCount,sum,[groupRedModel.totalMoney floatValue]];
    }
    if (groupRedModel.state == 3) {
        
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        
        for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
            
            NSString * userID = [NSString stringWithFormat:@"%ld",sendUser.id];
            
            [array addObject:userID];
            
        }
        
        NSLog(@"------array-----------%@",array);
        
        if ([array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"]]) {
            NSLog(@"我 自己在里面");
            _mianHintLabel.text = SelfRobOut;
            _subHintLabel.text  = EmptyHint;
        }else{
            
            _mianHintLabel.text = RobOut;
            _subHintLabel.text  = EmptyHint;
        }
        
        
//        _mianHintLabel.text = RobOut;
//        _subHintLabel.text  = EmptyHint;
        _totalCoinsLabel.hidden = NO;
        NSString * redTimeStr;
        if ([groupRedModel.overTime intValue] == 0) {
            redTimeStr = [NSString stringWithFormat:@"1s内"];
        }else if ([groupRedModel.overTime intValue] > 0 && [groupRedModel.overTime intValue] < 60){
            redTimeStr = [NSString stringWithFormat:@"%@s",groupRedModel.overTime];
        }else if ([groupRedModel.overTime intValue] > 60 && [groupRedModel.overTime intValue] < 3600){
            redTimeStr = [NSString stringWithFormat:@"%d分钟",[groupRedModel.overTime intValue]/60];
        }else if ([groupRedModel.overTime intValue] > 3600){
            redTimeStr = [NSString stringWithFormat:@"%d小时",[groupRedModel.overTime intValue]/3600];
        }
        //
        _redNoticeLabel.text = [NSString stringWithFormat:@"%d个红包共%.2f元,%@被抢完",groupRedModel.redpkCount,[groupRedModel.totalMoney floatValue],redTimeStr];
    }

    
}

#pragma mark -- TV
-(void)TVConfigGroupRedWith:(NewGroupDetailModel *)groupRedModel{
    
    _redNoticeView.hidden = NO;
    _redNoticeLabel.hidden = NO;
    _redViewHeight.constant = 29;
    _redPacketTitleLabel.text = groupRedModel.remark;
    //拼手气红包??
    if (groupRedModel.count == 2) {
        _luckMarkLabel.hidden = NO;
    } else {
        _luckMarkLabel.hidden = YES;
    }
    //发送人info
    [_senderImageView setImageUPSUrl:groupRedModel.sendUser.portrail];
    _senderNameLabel.text = [NSString stringWithFormat:@"%@的红包", groupRedModel.sendUser.name];
    
    for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
        
        if (sendUser.id == [[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"] integerValue]) {
            
            //金额
            NSString *totalCoinsString =  [NSString stringWithFormat:@"%@ TV",[NSString removeFloatAllZero:([sendUser.money doubleValue]/1000.0)]];
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalCoinsString attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:50], NSForegroundColorAttributeName: RedPacketColor}];
            
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(totalCoinsString.length - 3, 3)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR_HEX(0x4A4A4A) range:NSMakeRange(totalCoinsString.length - 3, 3)];
            
            _totalCoinsLabel.attributedText = attributedStr;
        }else{
            
            _totalCoinsLabel.text = @" ";
        }
    }
    
    _mianHintLabel.text = EmptyHint;
    _subHintLabel.text = ReciverHintOpend;
    //
    float sum = 0;
    for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
        
        sum = [sendUser.money floatValue] + sum;
    }
    //
    _redNoticeLabel.text = [NSString stringWithFormat:@"已领取%d/%d个,共%@/%.3fTV",groupRedModel.snatchedCount,groupRedModel.redpkCount,[NSString removeFloatAllZero:(sum/1000.0)],[groupRedModel.totalMoney doubleValue]/1000.0];
    
    //0-未领取 ，1-已领取， 2-已过期  3-已抢完(自己没有抢到)
    if (groupRedModel.state == 2) {
        _mianHintLabel.text = PastDue;
        _subHintLabel.text  = EmptyHint;
        _totalCoinsLabel.hidden = YES;
        //
        float sum = 0;
        for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
            
            sum = [sendUser.money floatValue] + sum;
        }
        
        _redNoticeLabel.text = [NSString stringWithFormat:@"已领取%d/%d个,共%@/%.3fTV",groupRedModel.snatchedCount,groupRedModel.redpkCount,[NSString removeFloatAllZero:(sum/1000.0)],[groupRedModel.totalMoney doubleValue]/1000.0];
    }
    if (groupRedModel.state == 3) {
        
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        
        for (GroupGetModel * sendUser in groupRedModel.receiveUserList) {
            
            NSString * userID = [NSString stringWithFormat:@"%ld",sendUser.id];
            
            [array addObject:userID];
            
        }
        
        NSLog(@"------array-----------%@",array);
        
        if ([array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"]]) {
            NSLog(@"我 自己在里面");
            
            _mianHintLabel.text = SelfRobOut;
            _subHintLabel.text  = EmptyHint;
        }else{
            
            _mianHintLabel.text = RobOut;
            _subHintLabel.text  = EmptyHint;
        }
        
//        _mianHintLabel.text = RobOut;
//        _subHintLabel.text  = EmptyHint;
        _totalCoinsLabel.hidden = NO;
        NSString * redTimeStr;
        if ([groupRedModel.overTime isEqualToString:@"0"]) {
            redTimeStr = [NSString stringWithFormat:@"1s内"];
        }else if ([groupRedModel.overTime intValue] > 0 && [groupRedModel.overTime intValue] < 60){
            redTimeStr = [NSString stringWithFormat:@"%@s",groupRedModel.overTime];
        }else if ([groupRedModel.overTime intValue] > 60 && [groupRedModel.overTime intValue] < 3600){
            redTimeStr = [NSString stringWithFormat:@"%d分钟",[groupRedModel.overTime intValue]/60];
        }else if ([groupRedModel.overTime intValue] > 3600){
            redTimeStr = [NSString stringWithFormat:@"%d小时",[groupRedModel.overTime intValue]/3600];
        }
        //
        _redNoticeLabel.text = [NSString stringWithFormat:@"%d个红包共%.3fTV,%@被抢完",groupRedModel.redpkCount,[groupRedModel.totalMoney doubleValue]/1000,redTimeStr];
    }

}


@end
