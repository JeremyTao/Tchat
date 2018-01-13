//
//  NewNewsCell.h
//  btc123
//
//  Created by btc123 on 17/1/16.
//  Copyright © 2017年 btc123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewNewsCell : UITableViewCell

//新闻图片
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
//新闻标题
@property (weak, nonatomic) IBOutlet UILabel *NewsTitleLabel;
//阅览人数
@property (weak, nonatomic) IBOutlet UILabel *readPeopleNumLabel;
//日期
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;


@property (nonatomic,strong) News * news;
@end
