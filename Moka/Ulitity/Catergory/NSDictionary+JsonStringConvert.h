//
//  NSDictionary+JsonStringConvert.h
//  InnerBuy
//
//  Created by Knight on 5/20/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonStringConvert)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
