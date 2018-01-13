//
//  MKPayRedPacketModel.h
//  Moka
//
//  Created by btc123 on 2017/12/29.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBasic.h"
#import "MKRedPaymodel.h"

@interface MKPayRedPacketModel : MKBasic

PRO_STR(redSize);                           //红包个数
PRO_STR(allmoney);                          //红包总金额
PRO_ARR(redList);                           //

@end
