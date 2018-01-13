//
//  MKNoneJoinedCircleTableViewCell.h
//  Moka
//
//  Created by Knight on 2017/9/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKNoneJoinedCircleTableViewCellDelegate <NSObject>

- (void)seeRecomandCirclesButtonClicked;

@end

@interface MKNoneJoinedCircleTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MKNoneJoinedCircleTableViewCellDelegate> delegate;

@end
