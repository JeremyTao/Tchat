//
//  RedPacketTypeHomeViewController.h
//  Moka
//
//  Created by btc123 on 2017/12/23.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketTypeHomeViewController : UIViewController

//房间号
@property (nonatomic,copy) NSString *targetID;
//红包类型
@property (nonatomic,copy) NSString *type;         //PRIVATE:个人   GROUP:群
//群里的人数
@property (nonatomic, assign) NSInteger number;

@end
