//
//  MKShareGroupView.h
//  Moka
//
//  Created by  moka on 2017/8/2.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPeopleModel.h"

@protocol MKShareGroupViewDelegate <NSObject>


- (void)confirmSharePeople:(MKPeopleModel *)model toUser:(NSString *)targetID;

@end

@interface MKShareGroupView : UIView

@property (nonatomic, weak) id<MKShareGroupViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

+ (instancetype)newShareGroupView;
- (void)show;
- (void)hide;
- (void)configView:(MKPeopleModel *)model toTargetUser:(NSString *)targetID;

@end
