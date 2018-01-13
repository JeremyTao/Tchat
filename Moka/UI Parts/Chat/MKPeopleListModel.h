//
//  MKPeopleListModel.h
//  Moka
//
//  Created by  moka on 2017/8/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKPeopleListModel : MKBasic

PRO_NUM(userid); //该用户的id
PRO_NUM(coveruserid);//自己的id
PRO_STR(img);
PRO_STR(name);
PRO_NUM(havaRead);
PRO_NUM(sex);
PRO_NUM(age);
PRO_STR(phone);
PRO_STR(remark);
PRO_STR(loginTime);
PRO_STR(createtime);
PRO_NUM(ifhave);


@end
