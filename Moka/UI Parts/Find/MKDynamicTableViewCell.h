//
//  MKDynamicTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDynamicListModel.h"


@protocol MKDynamicTableViewCellDelegate <NSObject>

@optional

- (void)giveMokaCoinButtonClickedAtIndex:(NSInteger)index;
- (void)likeDynamicButtonClickedAtIndex:(NSInteger)index status:(NSInteger)status;
- (void)commentButtonClickedAtIndex:(NSInteger)index;
- (void)tapedUserHeadImageAtIndex:(NSInteger)index;
- (void)moreOptionButtonClickedAtIndex:(NSInteger)index;

@end

typedef enum : NSUInteger {
    DynamicCellTypeHome,
    DynamicCellTypeDetail
} DynamicCellType;

@interface MKDynamicTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellRowIndex;
@property (nonatomic, assign) DynamicCellType type;
@property (nonatomic, weak) id<MKDynamicTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shadowViewTop;

- (void)configDynamicCell:(MKDynamicListModel *)model parentViewController:(UIViewController *)parentVC;

@end
