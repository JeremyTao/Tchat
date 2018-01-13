//
//  MKGroupInfoViewController.h
//  Moka
//
//  Created by  moka on 2017/8/1.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKCircleListModel.h"


@interface MKGroupInfoViewController : MKBaseViewController


@property (nonatomic, strong) MKCircleListModel *circleListModel;
@property (nonatomic, strong) NSString *cicleId;

@end
