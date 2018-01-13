//
//  MKHelloFansCountModel.h
//  Moka
//
//  Created by  moka on 2017/8/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKHelloFansCountModel : MKBasic

PRO_NUM(followSize);    //新粉丝数量
PRO_STR(follow);        //最近一个粉丝名称
PRO_STR(followTime);    //粉丝日期

PRO_NUM(sayHelloSize);  //打招呼的人数量
PRO_STR(sayHello);      //最近一条打招呼名称
PRO_STR(sayHelloTime);   //打招呼日期



@end
