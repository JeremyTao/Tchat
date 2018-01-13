//
//  MKFollowListViewController.h
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPeopleModel.h"

@protocol MKFollowListViewControllerDelegate <NSObject>

- (void)sendBusinessCard:(MKPeopleModel *)userModel toUser:(NSString *)targetID;

@end

@interface MKFollowListViewController : UIViewController

@property (nonatomic, weak) id<MKFollowListViewControllerDelegate>delegate;

@property (nonatomic,assign) BOOL  isShare;

@property (nonatomic, strong) RCUserInfo *shareUser;



- (void)changeTitle:(NSString *)title;

@end
