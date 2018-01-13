//
//  MKRedPaymodel.h
//  Moka
//
//  Created by btc123 on 2017/12/29.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBasic.h"

@interface MKRedPaymodel : MKBasic

#pragma mark -- 发出的红包
PRO_NUM(uid);                           //红包uid
PRO_NUM(state);                         //红包状态，0:未领取, 1:已领取，2:已过期，3-已抢完
PRO_NUM(count);                         //红包类型，1：个人红包，2：圈子随机红包，3：圈子固定红包
PRO_STR(totalMoney);                    //红包金额
PRO_NUM(cointype);                      //金额类型
PRO_NUM(redpkCount);                    //红包个数
PRO_NUM(snatchedCount);                 //已抢红包个数
PRO_NUM(createtime);                    //抢红包时间

@end
