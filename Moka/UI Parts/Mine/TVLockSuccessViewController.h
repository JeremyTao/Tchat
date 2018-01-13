//
//  TVLockSuccessViewController.h
//  Moka
//
//  Created by btc123 on 2017/12/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseViewController.h"

@interface TVLockSuccessViewController : MKBaseViewController

@property (nonatomic,copy) NSString *Suc;
//收到传来的时间
@property (copy, nonatomic) NSString * startTimeStr;
@end
