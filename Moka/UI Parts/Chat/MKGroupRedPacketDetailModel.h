//
//  MKGroupRedPacketDetailModel.h
//  Moka
//
//  Created by  moka on 2017/9/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"
#import "MKGroupRedGetModel.h"


@interface MKGroupRedPacketDetailModel : MKBasic

PRO_NUM(status); //0-未领取 ，1-已领取， 2-已过期  3-已抢完(自己没有抢到)
PRO_NUM(type);   //1.普通群红包， 2.拼手气群红包
PRO_ARR(listRed);
PRO_STR(selImgs);
PRO_STR(selName);
@property (nonatomic, strong) MKGroupRedGetModel *own;



@end
