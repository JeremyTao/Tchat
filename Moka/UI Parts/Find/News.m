//
//  News.m
//  btc123
//
//  Created by jarze on 16/1/7.
//  Copyright © 2016年 btc123. All rights reserved.
//

#import "News.h"

@implementation News
- (instancetype)initWithNSDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.image = dic[@"photoStr"];
        
        NSTimeInterval time = [dic[@"addTime"] doubleValue]/1000;
        NSDate * detaildate = [NSDate dateWithTimeIntervalSince1970:time];
        
        self.time = [self timeForDate:detaildate];
            
        self.title = [NSString stringWithFormat:@"%@", dic[@"title"]];
        self.count = [NSString stringWithFormat:@"%@", dic[@"click"]];
        
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.content = [NSString stringWithFormat:@"%@",dic[@"content"]];
        
        self.sourceUrl = [NSString stringWithFormat:@"%@",dic[@"sourceUrl"]];
        self.remark = [NSString stringWithFormat:@"%@",dic[@"remark"]];
        
        self.newsUrl = [NSString stringWithFormat:@"http://m.btc123.com/news/newsDetail?id=%@",self.Id];
    }
    return self;

}

- (NSString *)timeForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [dateFormatter stringFromDate: date];
    return string;
}
@end
