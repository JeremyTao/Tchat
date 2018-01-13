//
//  MKDynamicHeaderView.h
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKDynamicHeaderViewDelegate <NSObject>

- (void)didClickedHeaderView;

@end

@interface MKDynamicHeaderView : UIView

@property (nonatomic, weak) id<MKDynamicHeaderViewDelegate> delegate;

+ (instancetype)newView;

- (void)configWithInfo:(NSDictionary *)info;



@end
