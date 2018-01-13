//
//  MKUnreadMessageModel.h
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKUnreadMessageModel : MKBasic

PRO_NUM(ifdel);  //类型说明: 1=评论 2=点赞 3=打赏
PRO_STR(replyName);//用户名
PRO_STR(img);      //用户头像
PRO_STR(createtime); //日期
PRO_STR(commenttext); //评论内容 (ifdel = 1时有效)
PRO_NUM(messageid);   //动态ID
PRO_STR(messageimg);   //动态图片
PRO_NUM(ifhave);

@end
