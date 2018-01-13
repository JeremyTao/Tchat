//
//  alipayChargeBillModel.h
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface alipayChargeBillModel : NSObject

PRO_NUM(type);           //类型 1：充值，2：提现，3：发个人红包，4：发圈子随机红包，5：发圈子固定红包 ，6：收到个人红包，7：收到圈子随机红包，8：收到圈子固定红包，9：红包退款，10：打赏别人，11：别人打赏，12：加入圈子，13：别人加入圈子
PRO_STR(totalMoney);          //金额
PRO_STR(time);           //时间
PRO_NUM(status);         //状态  0:已提交，处理/审核中 1 处理/审核成功 2 处理/审核失败
PRO_STR(userid);         //操作用户id，发个人红包/收到红包/打赏/别人加入圈子：对方userid
PRO_STR(name);           //昵称
PRO_STR(repkUserName);   //备注
PRO_STR(sourceid);       //源id，充值：订单号，提现：提现id，红包：红包uid，打赏：动态id，加入圈子：圈子id

@end
