//
//  MKInOutRedPacketModel.h
//  Moka
//
//  Created by  moka on 2017/8/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKInOutRedPacketModel : MKBasic

#pragma mark -- 我收到的红包

PRO_STR(redSize);                               //收到的红包个数
PRO_STR(allmoney);                              //收到的红包总金额
PRO_STR(luckcount);                             //手气最佳
PRO_ARR(redList);                               //详情



@end
