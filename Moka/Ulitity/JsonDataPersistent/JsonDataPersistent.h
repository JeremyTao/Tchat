//
//  JsonDataPersistent.h
//  CrunClub
//
//  Created by Knight on 8/15/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonDataPersistent : NSObject

+ (void)saveJsonData:(id)jsonData withName:(NSString *)dataName;

+ (id)readJsonDataWithName:(NSString *)dataName;

@end
