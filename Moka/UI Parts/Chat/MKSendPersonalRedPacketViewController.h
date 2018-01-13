//
//  MKSendPersonalRedPacketViewController.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKRedPacketMessageContent.h"

@interface MKSendPersonalRedPacketViewController : UIViewController

//房间号
@property (nonatomic, copy) NSString *targetId;
//
@property (nonatomic, copy) NSString *coinType;       //红包类型  1 : RMB   2:TV
@end
