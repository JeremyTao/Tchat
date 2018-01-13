//
//  MKCircleMemberModel.h
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBasic.h"

@interface MKCircleMemberModel : MKBasic

PRO_NUM(userid);
PRO_STR(time);
PRO_STR(img);
PRO_STR(name);
PRO_NUM(age);
PRO_NUM(sex);
PRO_NUM(ifhave); //0.不是大咖， 1.是
PRO_NUM(ifmaster); //= 1    //圈主

@property (nonatomic, strong) UIImage *addImage;

@end
