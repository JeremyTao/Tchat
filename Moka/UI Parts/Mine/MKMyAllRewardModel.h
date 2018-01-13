//
//  MKMyAllRewardModel.h
//  Moka
//
//  Created by Knight on 2017/9/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKMyAllRewardModel : MKBasic

PRO_NUM(ifhave); //0 自己发的， 1接收的
PRO_STR(createtime);
PRO_STR(name);
PRO_STR(imgs);
PRO_NUM(type);
PRO_NUM(money);
PRO_STR(txid);

@end
