//
//  MKTradingTableViewCell.m
//  Moka
//
//  Created by  moka on 2017/8/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKTradingTableViewCell.h"

@interface MKTradingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *theImageView;

@property (weak, nonatomic) IBOutlet UILabel *tradeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *translateIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *txIdLabel;

@end

@implementation MKTradingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configRedPacketCellWith:(MKMyAllRedPacketModel *)redPacketmodel {
    [self resetCellData];
    if ([redPacketmodel.txid isEqualToString:@""] || redPacketmodel.txid == NULL) {
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"红包没有txId";
    }
    if (redPacketmodel.state == 2) {
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"红包已过期,TV将自动转入账户";
    }
    NSString *money = [NSString stringWithFormat:@"%@TV",[NSString removeFloatAllZero:redPacketmodel.money / 1000.0]];
    
    if (redPacketmodel.userid == [[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"] integerValue]) {
        //自己发出的红包
        if (redPacketmodel.state == 2) {
            _tradeTitleLabel.text = [NSString stringWithFormat:@"+%@",money];
        }else{
            _tradeTitleLabel.text = [NSString stringWithFormat:@"给%@的红包：-%@", redPacketmodel.name, money];
        }
        
    } else {
        //自己接受的红包
        _tradeTitleLabel.text = [NSString stringWithFormat:@"收到%@的红包：+%@", redPacketmodel.name, money];
    }
    
    [_theImageView setImageUPSUrl:redPacketmodel.imgs];
    
    _dateLabel.text = redPacketmodel.createtime;
}

- (void)configWithdrawCellWith:(MKMyWithdrawModel *)withdrawModel {
    
    [self resetCellData];
    NSString *money = [NSString stringWithFormat:@"%@TV",[NSString removeFloatAllZero:withdrawModel.money / 1000.0]];
    
    if (withdrawModel.success == 0) {
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"审核中";
        _tradeTitleLabel.text = [NSString stringWithFormat:@"提现：-%@",  money];
    }else if (withdrawModel.success == 3){
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"审核失败";
        _tradeTitleLabel.text = [NSString stringWithFormat:@"提现：+%@",  money];
    }else{
        _txIdLabel.text = [NSString stringWithFormat:@"%@",withdrawModel.txid];
        _tradeTitleLabel.text = [NSString stringWithFormat:@"提现：-%@",  money];
    }

    _dateLabel.text = withdrawModel.createtime;
    _theImageView.image = IMAGE(@"check_withdraw");
}

- (void)configRechargeCellWith:(MKRechargeModel *)rechargeModel {
   
    [self resetCellData];
    
    NSString *money = [NSString stringWithFormat:@"%@TV",[NSString removeFloatAllZero:rechargeModel.money / 1000.0]];

    
    if (rechargeModel.success == 0) {
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"审核中";
        _tradeTitleLabel.text = [NSString stringWithFormat:@"充值：+%@",  money];
        
    }else if (rechargeModel.success == 3){
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"审核失败";
        _tradeTitleLabel.text = [NSString stringWithFormat:@"充值：+%@",  money];
    }else{
        _txIdLabel.text = [NSString stringWithFormat:@"%@",rechargeModel.txid];
        _tradeTitleLabel.text = [NSString stringWithFormat:@"充值：+%@",  money];
    }

    _dateLabel.text = rechargeModel.createtime;
    _theImageView.image = IMAGE(@"check_recharge");
}

- (void)configICOCellWith:(MKMyICOModel *)icoModel {
    [self resetCellData];
    NSString *money = [NSString stringWithFormat:@"%@TV",[NSString removeFloatAllZero:icoModel.total / 1000.0]];
    
    if (icoModel.userid == [[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_USER_ID"] integerValue]) {
        //自己参投的ICO
        _tradeTitleLabel.text = [NSString stringWithFormat:@"参投❲%@❳圈ICO：-%@TV",icoModel.circleName, money];
    } else {
        //自己发起的ICO, 别人参投的
        _tradeTitleLabel.text = [NSString stringWithFormat:@"❲%@❳参投❲%@❳圈ICO：+%@TV", icoModel.name,icoModel.circleName, money];
    }
    
    _dateLabel.text = icoModel.createtime;
    [_theImageView setImageUPSUrl:icoModel.circleImg];
    
    
}


- (void)configCircleJoinCellWith:(MKCircleJoinModel *)circleModel {
    [self resetCellData];
    NSString *money = [NSString stringWithFormat:@"%@TV",[NSString removeFloatAllZero:circleModel.money / 1000.0]];
    if (circleModel.ifhave == 0) {
        //0 我加入的圈子
        _tradeTitleLabel.text = [NSString stringWithFormat:@"加入%@圈子：-%@", circleModel.name, money];
    } else {
        //0 别人加入我的圈子
        _tradeTitleLabel.text = [NSString stringWithFormat:@"%@加入圈子：+%@", circleModel.name, money];
    }
    _dateLabel.text = circleModel.createtime;
    [_theImageView setImageUPSUrl:circleModel.imgs];
}



- (void)configGiftCellWith:(MKMyAllGiftModel *)giftModel {
    
    [self resetCellData];
    if ([giftModel.txid isEqualToString:@""] || giftModel.txid == NULL) {
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"礼物没有txId";
    }
    if (giftModel.state == 2) {
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"礼物已过期,TV将自动转入账户";
    }
    if (giftModel.ifhave == 0) {
        //自己发起礼物
        _tradeTitleLabel.text = [NSString stringWithFormat:@"给%@的礼物：-40TV", giftModel.name];
    } else {
        //自己接受的礼物
        _tradeTitleLabel.text = [NSString stringWithFormat:@"收到%@的礼物：+40TV", giftModel.name];
    }
    
    _dateLabel.text = giftModel.createtime;
    [_theImageView setImageUPSUrl:giftModel.imgs];
}

- (void)configMyAllRewardModelCellWith:(MKMyAllRewardModel *)rewardModel {
    [self resetCellData];
    if ([rewardModel.txid isEqualToString:@""] || rewardModel.txid == NULL) {
        _translateIDLabel.text = @"状态:";
        _txIdLabel.text = @"打赏没有txId";
    }
    if (rewardModel.ifhave == 0) {
        //自己打赏别人
        
        _tradeTitleLabel.text = [NSString stringWithFormat:@"打赏%@：-%@TV", rewardModel.name, [NSString removeFloatAllZero:rewardModel.money / 1000.0]];
    } else {
        _tradeTitleLabel.text = [NSString stringWithFormat:@"收到%@的打赏：+%@TV", rewardModel.name, [NSString removeFloatAllZero:rewardModel.money / 1000.0]];
    }
    _dateLabel.text = rewardModel.createtime;
    [_theImageView setImageUPSUrl:rewardModel.imgs];
}

- (void)resetCellData {
    _theImageView.image = nil;
    _translateIDLabel.text = @"txId:";
    _txIdLabel.text = @"";
    _tradeTitleLabel.text = @"";
    _dateLabel.text = @"";
    
}

@end
