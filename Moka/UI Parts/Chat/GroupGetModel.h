//
//  GroupGetModel.h
//  Moka
//
//  Created by btc123 on 2017/12/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBasic.h"

@interface GroupGetModel : MKBasic

//抢红包的用户
PRO_STR(money);                             //抢到的红包金额
PRO_NUM(time);                              //抢红包的时间单位毫秒
PRO_NUM(id);                                //用户ID
PRO_STR(name);                              //用户名
PRO_STR(phone);                             //手机号
PRO_NUM(sex);                               //性别
PRO_NUM(ifhave);                            //是否大咖
PRO_STR(portrail);                          //头像
PRO_STR(remarksName);                       //昵称备注

@end
