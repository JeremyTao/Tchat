//
//  MKCommentModel.h
//  Moka
//
//  Created by  moka on 2017/8/9.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKCommentModel : MKBasic


PRO_NUM(id);           //评论id
PRO_STR(commenttext);
PRO_NUM(replycomid);   // 0: 第一级评论
PRO_NUM(userid);       //用户id
PRO_STR(img);          //用户头像
PRO_NUM(messageid);    //动态id
PRO_STR(createtime);
PRO_STR(name);
PRO_ARR(dataList);
PRO_NUM(ifdel);  // 是否是自己的评论

@end
