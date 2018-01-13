//
//  MKFilterPeopleViewController.h
//  Moka
//
//  Created by Knight on 2017/7/21.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"

@protocol MKFilterPeopleViewControllerDelegate <NSObject>

- (void)didSelectFilterWithGender:( NSString *)gender smallAge:(NSInteger)smallAge largeAge:(NSInteger)largeAge;

@end

@interface MKFilterPeopleViewController : MKBaseViewController

@property (nonatomic, weak) id<MKFilterPeopleViewControllerDelegate> delegate;

@end
