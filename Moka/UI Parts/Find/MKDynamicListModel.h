//
//  MKDynamicListModel.h
//  Moka
//
//  Created by  moka on 2017/8/8.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKDynamicListModel : MKBasic

PRO_NUM(state);
PRO_NUM(id);      
PRO_NUM(ifdel);  // 是否是自己的动态
PRO_STR(name);
PRO_NUM(userid);
PRO_STR(time);
PRO_STR(img);  //用户头像
PRO_STR(imgs); //动态配图
PRO_NUM(commentnum);
PRO_NUM(rewardNum);
PRO_STR(text);
PRO_NUM(ifThing);  //0 未点赞 1 已点赞
PRO_NUM(thingnum);


@end
