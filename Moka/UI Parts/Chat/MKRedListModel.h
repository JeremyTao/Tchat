//
//  MKRedListModel.h
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKRedListModel : MKBasic

#pragma mark -- 收到的红包
PRO_NUM(uid);                           //红包uid
PRO_STR(money);                         //红包金额
PRO_NUM(count);                         //红包类型
PRO_NUM(coinType);                      //金额类型
PRO_STR(repkUserName);                  //发红包用户备注，注意先获取对其设置的备
PRO_STR(name);                          //发红包用户昵称，注意先获取对其设置的备注
PRO_STR(remark);                        //红包备注
PRO_NUM(endtime);                       //抢红包时间


@end
