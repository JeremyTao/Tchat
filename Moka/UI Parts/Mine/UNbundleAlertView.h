//
//  UNbundleAlertView.h
//  Moka
//
//  Created by btc123 on 2017/12/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AlertResult)(NSInteger index);
@interface UNbundleAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;
-(instancetype)initNnbundleAlertView:(NSString *)title;
-(void)showAlertView;
@end
