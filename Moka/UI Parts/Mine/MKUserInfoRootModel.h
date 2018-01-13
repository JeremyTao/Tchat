//
//  MKUserInfoRootModel.h
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKUserInfoRootModel : MKBasic

PRO_STR(birthday);
PRO_NUM(status);
PRO_NUM(money);
PRO_ARR(mylableList);
PRO_NUM(sex);
PRO_STR(logintime);
PRO_STR(name);
PRO_NUM(feeling);
PRO_NUM(id);
PRO_ARR(foodList);
PRO_ARR(motionList);
PRO_STR(phone);
PRO_STR(createtime);
PRO_ARR(filmList);
PRO_STR(portrail);
PRO_ARR(portrailList);
PRO_STR(industryName);
PRO_STR(address);
PRO_STR(autograph);
PRO_STR(code);      //用户ID
PRO_NUM(ifhave);    //是否是大v
PRO_NUM(coverCount);
PRO_NUM(count);

@end
