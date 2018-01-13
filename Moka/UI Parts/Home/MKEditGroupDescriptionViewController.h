//
//  MKEditGroupDescriptionViewController.h
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKCircleInfoModel.h"
#import "MKCircleListModel.h"

@interface MKEditGroupDescriptionViewController : MKBaseViewController

@property (nonatomic, strong) MKCircleInfoModel *circleModel; //圈子model
@property (nonatomic, strong) MKCircleListModel *circleListModel; //圈子列表model

@end
