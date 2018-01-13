//
//  MKEditCircleTagsViewController.h
//  Moka
//
//  Created by  moka on 2017/8/3.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKCircleInfoModel.h"
#import "MKCircleListModel.h"

@interface MKEditCircleTagsViewController : MKBaseViewController

@property (nonatomic, strong) MKCircleInfoModel *circleModel; //圈子model
@property (nonatomic, strong) MKCircleListModel *circleListModel; //圈子列表model

@end
