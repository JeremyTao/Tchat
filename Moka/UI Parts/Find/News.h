//
//  News.h
//  btc123
//
//  Created by jarze on 16/1/7.
//  Copyright © 2016年 btc123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *count;


@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *Id;

@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * viewCount;

@property (nonatomic, copy) NSString *newsUrl;
@property (nonatomic, copy) NSString *movieUrl;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;
@end
