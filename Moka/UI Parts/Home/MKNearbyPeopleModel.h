//
//  MKNearbyPeopleModel.h
//  Moka
//
//  Created by  moka on 2017/8/2.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKNearbyPeopleModel : MKBasic

PRO_NUM(id);
PRO_STR(portrail);
PRO_STR(name);
PRO_NUM(ifhave);   //0 :普通用户 ,  1 : 大V
PRO_NUM(ifFollow);

@end
