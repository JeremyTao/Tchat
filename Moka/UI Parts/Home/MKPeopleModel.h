//
//  MKPeopleModel.h
//  Moka
//
//  Created by  moka on 2017/8/12.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKPeopleModel : MKBasic

PRO_NUM(userid);    //自己id
PRO_NUM(coveruserid); //id
PRO_STR(name);
PRO_STR(img);
PRO_NUM(sex);
PRO_NUM(age);
PRO_STR(phone);
PRO_NUM(select);
PRO_NUM(ifhave);

@end
