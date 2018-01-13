//
//  MKCircleInfoModel.h
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"
#import "MKCircleMemberModel.h"

@interface MKCircleInfoModel : MKBasic

PRO_NUM(id);           //圈子id
PRO_NUM(userid);       //圈主的userid
PRO_STR(name);         //圈主的名字
PRO_STR(introduce);    //圈子介绍
PRO_STR(imgs);         //圈子头像
PRO_NUM(pay);          //支付TV币
PRO_NUM(ifpay);        //是否需要付费   0:不需要 1:需要
PRO_STR(time);         //圈子创建时间
PRO_NUM(count);        //成员数量
PRO_NUM(notice);       //0.未开启 1.开启
PRO_STR(nickNameInCircle);  //我在圈子中的昵称 （新接口）
PRO_NUM(ifmember);     //1.成员 2.非成员 3.管理员
PRO_ARR(lableList);    //群标签


PRO_NUM(code);
PRO_ARR(memberList);  //新接口没有 旧接口有
PRO_NUM(ifico); //0.没有ico， 1.正在ico
PRO_STR(remarkName); //我在圈子的昵称 (旧接口)

@property (nonatomic,strong) MKCircleMemberModel * adminInfo; //圈子中群主的信息  新接口有 旧接口没有

@end
