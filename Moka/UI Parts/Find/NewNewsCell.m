//
//  NewNewsCell.m
//  btc123
//
//  Created by btc123 on 17/1/16.
//  Copyright © 2017年 btc123. All rights reserved.
//

#import "NewNewsCell.h"
#import "UIImageView+WebCache.h"

@implementation NewNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//数据显示
-(void)setNews:(News *)news
{
    _news = news;
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:_news.image] placeholderImage:[UIImage imageNamed:@"failLoadImage.png"]];
    
    //是否剪切掉超出 UIImageView 范围的图片
    self.newsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.newsImageView.clipsToBounds = YES;
    //标题
    self.NewsTitleLabel.text = news.title;
    self.NewsTitleLabel.textColor = RGBCOLOR(42, 42, 42);
    //时间
    self.dataLabel.text = news.time;
    //浏览人数
    self.readPeopleNumLabel.text = news.count;
    
}

@end
