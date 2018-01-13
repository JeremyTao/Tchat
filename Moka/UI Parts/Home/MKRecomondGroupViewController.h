//
//  MKRecomondGroupViewController.h
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKCircleListModel.h"

@protocol MKRecomondGroupViewControllerDelegate <NSObject>

- (void)startSearchWithQuery:(NSString *)words;
- (void)didSelectCircle:(MKCircleListModel *)circleModel;
- (void)didClickedMyCircles;


@end

@interface MKRecomondGroupViewController : MKBaseViewController

@property (nonatomic, weak) id<MKRecomondGroupViewControllerDelegate> delegate;

- (void)scrollToTop;

@end
