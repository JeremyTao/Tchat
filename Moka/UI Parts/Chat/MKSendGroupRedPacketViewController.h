//
//  MKSendGroupRedPacketViewController.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKRedPacketMessageContent.h"


@interface MKSendGroupRedPacketViewController : UIViewController

@property (nonatomic, copy) NSString *circleId;
@property (nonatomic, assign) NSInteger numberOfPeople;
@property (nonatomic, copy) NSString *coinType;


@end
