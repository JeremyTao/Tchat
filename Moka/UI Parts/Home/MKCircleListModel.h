//
//  MKCircleListModel.h
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKCircleListModel : MKBasic

PRO_NUM(id);
PRO_STR(imgs);
PRO_STR(lableids);
PRO_STR(name);
PRO_STR(introduce);
PRO_NUM(count);
PRO_NUM(ifmember);//1  自己加入的圈子,  0 自己创建的圈子

@end
