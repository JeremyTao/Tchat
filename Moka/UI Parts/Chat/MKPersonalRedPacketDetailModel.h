//
//  MKPersonalRedPacketDetailModel.h
//  Moka
//
//  Created by  moka on 2017/8/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKPersonalRedPacketDetailModel : MKBasic

PRO_NUM(userid); //发红包的人的ID
PRO_NUM(receiveuserid);//接受人ID
PRO_STR(uid);//红包ID
PRO_STR(money); //红包金额
PRO_NUM(state); //红包状态
PRO_NUM(coinType);//金额类型,1:RMB，2：TV
//
PRO_STR(remark);   //标题
PRO_STR(selfName); //发送人姓名
PRO_STR(selfImgs); //发送人头像
PRO_STR(name);//抢红包人的姓名
PRO_STR(imgs);//抢红包人的头像
PRO_STR(createtime);//抢红包日期



















@end
