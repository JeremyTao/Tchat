//
//  Address.m
//  DYCPickView
//
//  Created by DYC on 15/9/10.
//  Copyright (c) 2015年 DYC. All rights reserved.
//

#import "Address.h"

@implementation Address
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sonAddress = [NSMutableArray array];
    }
    return self;
}


//解压
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        //这里的'key'与压缩的'key'必须保持一致
        _name = [aDecoder decodeObjectForKey:@"name"];
        _areaCode = [[aDecoder decodeObjectForKey:@"areaCode"] integerValue];
        _fatherCode = [[aDecoder decodeObjectForKey:@"fatherCode"] integerValue];
        _postCode = [[aDecoder decodeObjectForKey:@"postCode"] integerValue];
        _sonAddress = [aDecoder decodeObjectForKey:@"sonAddress"];
    }
    return self;
}


//压缩
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:@(_areaCode) forKey:@"areaCode"];
    [aCoder encodeObject:@(_fatherCode) forKey:@"fatherCode"];
    [aCoder encodeObject:@(_postCode) forKey:@"postCode"];
    [aCoder encodeObject:_sonAddress forKey:@"sonAddress"];
}
@end
