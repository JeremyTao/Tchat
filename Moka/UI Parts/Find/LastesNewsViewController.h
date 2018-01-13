//
//  LastesNewsViewController.h
//  btc123
//
//  Created by btc123 on 17/1/16.
//  Copyright © 2017年 btc123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@protocol LastesNewsDelegate <NSObject>

- (void)didSelectNewsDatas:(News *)dics;

@end

@interface LastesNewsViewController : UIViewController

@property (nonatomic, weak) id<LastesNewsDelegate> delegate;

- (void)scrollToTop;
@end
