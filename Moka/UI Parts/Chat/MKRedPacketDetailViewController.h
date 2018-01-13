//
//  MKRedPacketDetailViewController.h
//  Moka
//
//  Created by  moka on 2017/8/15.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKRedPacketMessageContent.h"



@interface MKRedPacketDetailViewController : UIViewController

@property (nonatomic, strong) MKRedPacketMessageContent *redPacketMessage;
@property (nonatomic, assign) RCConversationType  conversationType;

@end
