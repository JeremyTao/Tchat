//
//  AlipayBillsDetailViewController.h
//  Moka
//
//  Created by btc123 on 2017/12/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBaseViewController.h"

@interface AlipayBillsDetailViewController : MKBaseViewController

//金额
@property (nonatomic,copy) NSString *money;
//类型
@property (nonatomic,copy) NSString *type;
//时间
@property (nonatomic,copy) NSString *time;
//状态
@property (nonatomic,copy) NSString *status;
//交易单号
@property (nonatomic,copy) NSString *transID;
//备注
@property (nonatomic,copy) NSString *remark;

@end
