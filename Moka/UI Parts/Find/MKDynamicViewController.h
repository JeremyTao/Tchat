//
//  MKDynamicViewController.h
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"

@protocol MKDynamicViewControllerDelegate <NSObject>

- (void)didSelectDynamicAtIndex:(NSInteger)index withDynamicID:(NSInteger)dynamicID isShowKeyboard:(BOOL)show;
- (void)tapedUserHeadImageAtIndex:(NSInteger)index withUserID:(NSInteger)userID;
- (void)openUnreadMessageController;

@end

@interface MKDynamicViewController : MKBaseViewController

@property (nonatomic, weak) id<MKDynamicViewControllerDelegate> delegate;

- (void)configUnreadMessageWith:(NSDictionary *)infoDic;
- (void)scrollToTop;
@end
