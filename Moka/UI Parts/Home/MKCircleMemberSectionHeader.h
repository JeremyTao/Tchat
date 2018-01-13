//
//  MKCircleMemberSectionHeader.h
//  Moka
//
//  Created by  moka on 2017/8/7.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKCircleMemberSectionHeaderDelegate <NSObject>

- (void)didClickedUserInfoButton;
- (void)didClickedDynamicButton;

@end

@interface MKCircleMemberSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id<MKCircleMemberSectionHeaderDelegate> delegate;

@end
