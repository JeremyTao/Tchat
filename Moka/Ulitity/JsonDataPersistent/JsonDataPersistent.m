//
//  JsonDataPersistent.m
//  CrunClub
//
//  Created by Knight on 8/15/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "JsonDataPersistent.h"

@implementation JsonDataPersistent

+ (void)saveJsonData:(id)jsonObject withName:(NSString *)dataName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *json_path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", dataName]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    [jsonData writeToFile:json_path atomically:YES];
    NSLog(@"%@",[jsonData writeToFile:json_path atomically:YES] ? @"Succeed":@"Failed");
}

+ (id)readJsonDataWithName:(NSString *)dataName {
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *json_path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", dataName]];
    //==Json数据
    NSData *jsonData=[NSData dataWithContentsOfFile:json_path];
    if (!jsonData) {
        return nil;
    }
    
    id jsonObject=[NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingAllowFragments
                                                    error:nil];
    NSLog(@"%@",jsonObject);
    return jsonObject;
}

@end
