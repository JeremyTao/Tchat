//
//  MKSayHelloPopView.h
//  Moka
//
//  Created by  moka on 2017/8/17.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKSayHelloPopViewDelegate <NSObject>

- (void)didClickedGiveButton;


@end

@interface MKSayHelloPopView : UIView

@property (nonatomic, weak) id<MKSayHelloPopViewDelegate> delegate;

+ (instancetype)newPopView;
- (void)showInViewController:(UIViewController *)vc;
- (void)hide;

@end
