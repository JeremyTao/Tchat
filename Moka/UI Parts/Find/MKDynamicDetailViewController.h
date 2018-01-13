//
//  MKDynamicDetailViewController.h
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"


@interface MKDynamicDetailViewController : MKBaseViewController

@property (nonatomic, copy) NSString *dynamicId; //动态id



- (void)openCommentKeyboard;


@end
