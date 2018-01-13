//
//  withDrawSucViewController.h
//  Moka
//
//  Created by btc123 on 2017/12/18.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseViewController.h"

@interface withDrawSucViewController : MKBaseViewController

//是否提现成功
@property (nonatomic,copy) NSString *status;
//提现金额
@property (nonatomic,copy) NSString *money;
//手续费
@property (nonatomic,copy) NSString *fee;
//到账账号
@property (nonatomic,copy) NSString *account;
@end
