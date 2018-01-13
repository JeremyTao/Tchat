//
//  BalanceNoticeView.h
//  Moka
//
//  Created by btc123 on 2017/12/29.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AlertResult)(NSString *text);
@interface BalanceNoticeView : UIView

@property (nonatomic,copy) AlertResult resultText;
-(instancetype)initAlertView:(NSString *)title balance:(NSString *)myBalance;
-(void)showAlertView;
@end
