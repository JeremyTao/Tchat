//
//  NewGroupDetailModel.h
//  Moka
//
//  Created by btc123 on 2017/12/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBasic.h"
#import "GroupGetModel.h"

@interface NewGroupDetailModel : MKBasic


PRO_NUM(state);                             //红包状态
PRO_NUM(count);                             //红包类型
PRO_STR(totalMoney);                        //发送总金额
PRO_NUM(cointype);                          //金额类型,1:RMB，2：TV
PRO_NUM_int(redpkCount);                    //红包个数，个人红包固定为1
PRO_NUM_int(snatchedCount);                 //已抢红包个数
PRO_STR(remark);                            //备注
PRO_NUM(sendtime);                          //发红包时间单位毫秒
PRO_ARR(receiveUserList);                   //抢红包的用户
PRO_STR(overTime);                          //抢完红包的时间

@property (nonatomic,strong) GroupGetModel * sendUser;


@end
