//
//  MKCircleJoinModel.h
//  Moka
//
//  Created by  moka on 2017/9/22.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKCircleJoinModel : MKBasic

PRO_NUM(money);
PRO_NUM(ifhave); // 0 我加入的圈子， 1:别人加入我的
PRO_STR(createtime);
PRO_STR(name);
PRO_STR(imgs);
PRO_NUM(type);



@end
