//
//  MKNearbyPeopleViewController.h
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKNearbyPeopleModel.h"

@protocol MKNearbyPeopleViewControllerDelegate <NSObject>

- (void)didSelectPeople:(MKNearbyPeopleModel *)model;

@end




@interface MKNearbyPeopleViewController : MKBaseViewController

@property (nonatomic, weak) id<MKNearbyPeopleViewControllerDelegate> delegate;

- (void)filterWithGender:(NSString *)sex
                smallAge:(NSInteger)smallAge
                largeAge:(NSInteger)largeAge;


- (BOOL)isTop;
- (void)scrollToTop;

@end
