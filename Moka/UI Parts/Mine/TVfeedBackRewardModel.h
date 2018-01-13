//
//  TVfeedBackRewardModel.h
//  Moka
//
//  Created by btc123 on 2017/12/6.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface TVfeedBackRewardModel : MKBasic

PRO_NUM(locknum);                 //锁入的TV数量
PRO_STR(locktimes);               //锁入时间
PRO_NUM(givedInterest);           //这笔锁仓记录已累计收益的总量
PRO_NUM_int(backnum);             //已返还期数
PRO_NUM_int(islocal);             //锁定状态 0：正常 1：已解锁
PRO_STR(endtimes);                //到期时间

@end
