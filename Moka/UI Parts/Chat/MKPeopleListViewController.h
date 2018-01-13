//
//  MKPeopleListViewController.h
//  Moka
//
//  Created by  moka on 2017/8/14.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ListTypeNewFans,
    ListTypeSayHello
} ListType;

@interface MKPeopleListViewController : UIViewController

@property (nonatomic, assign) ListType listType;

@end
