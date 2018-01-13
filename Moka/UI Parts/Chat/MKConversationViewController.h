//
//  MKConversationViewController.h
//  Moka
//
//  Created by  moka on 2017/8/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface MKConversationViewController : RCConversationViewController

@property (nonatomic,assign) BOOL   ifSayHello;
@property (nonatomic, copy) NSString *sayHelloUserID;


@end
