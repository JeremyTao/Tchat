//
//  MKMyCirclesHeadView.h
//  Moka
//
//  Created by Knight on 2017/9/11.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKMyCirclesHeadView : UITableViewHeaderFooterView

+ (instancetype)newCirclesHeadView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
