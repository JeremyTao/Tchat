//
//  MKMyAllRedPacketModel.h
//  Moka
//
//  Created by  moka on 2017/8/27.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKMyAllRedPacketModel : MKBasic

PRO_NUM(id);
PRO_NUM(userid); //发送人id
PRO_STR(name);   //接受人名称
PRO_NUM(receiveuserid);//接受人id
PRO_NUM(money);
PRO_STR(createtime);
PRO_NUM(state);
PRO_STR(imgs);
PRO_STR(txid);


@end
