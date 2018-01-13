//
//  MKPeopleRootModel.h
//  Moka
//
//  Created by  moka on 2017/8/8.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKPeopleRootModel : MKBasic

PRO_NUM(id);
PRO_STR(name);      //姓名
PRO_STR(remarksName);//备注名
PRO_NUM(age);       //年龄
PRO_STR(address);   //来自
PRO_STR(phone);     //电话
PRO_STR(industryName);//行业
PRO_STR(birthday);  //生日
PRO_STR(autograph); //签名
PRO_NUM(sex);       //性别
PRO_NUM(feeling);   //情感
PRO_NUM(count);     //关注数
PRO_NUM(coverCount);//粉丝数
PRO_NUM(ifFollow);  //是否关注  0 未关注  1 关注
PRO_STR(code);      //用户ID
PRO_NUM(authentication); //是否认证 0  未认证  1 认证
PRO_NUM(ifSayHello); //是否打过招呼  0未打过。 1.打过

PRO_NUM(ifhave);   //0 不是大咖， 1 是
PRO_ARR(portrailList); //头像数组
PRO_ARR(foodList);
PRO_ARR(motionList);
PRO_ARR(filmList);
PRO_ARR(mylableList); //我的标签




@end
