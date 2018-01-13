//
//  MKCircleMemberViewController.h
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKNearbyPeopleModel.h"


@interface MKCircleMemberViewController : MKBaseViewController

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) MKNearbyPeopleModel *userModel;

@end
