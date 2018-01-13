//
//  MKCommentTableViewCell.h
//  Moka
//
//  Created by  moka on 2017/8/5.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDynamicCommentModel.h"

@interface MKCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *seperatorLine;


- (void)configCell:(MKDynamicCommentModel *)model;

@end
