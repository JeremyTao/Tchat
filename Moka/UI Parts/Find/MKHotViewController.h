//
//  MKHotViewController.h
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"

@protocol MKHotViewControllerDelegate <NSObject>


- (void)didSelectHotDynamicAtIndex:(NSInteger)index withDynamicID:(NSInteger)dynamicID isShowKeyboard:(BOOL)show;
- (void)tapedUserHeadHotImageAtIndex:(NSInteger)index withUserID:(NSInteger)userID;

@end

@interface MKHotViewController : MKBaseViewController

@property (nonatomic, weak) id<MKHotViewControllerDelegate> delegate;

- (void)scrollToTop;

@end
