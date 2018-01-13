//
//  MKEditHobbyTagsViewController.h
//  Moka
//
//  Created by  moka on 2017/7/28.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKUserInfoRootModel.h"

typedef enum : NSUInteger {
    HobbyTypeNone,
    HobbyTypeMovies,
    HobbyTypeFoods,
    HobbyTypeSports,
} HobbyType;

@interface MKEditHobbyTagsViewController : MKBaseViewController

@property (nonatomic, assign) HobbyType myHobby;
@property (nonatomic ,strong) MKUserInfoRootModel *infoModel;

@end
