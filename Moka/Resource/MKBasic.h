//
//  MKBasic.h
//  Moka
//
//  Created by Knight on 2017/7/19.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PRO_STR(str) @property (nonatomic,copy) NSString *str
#define PRO_ARR(arr) @property (nonatomic,strong) NSArray *arr
#define PRO_DICT(dict) @property (nonatomic,strong) NSDictionary *dict
#define PRO_NUM(i) @property (nonatomic,assign) NSInteger i
#define PRO_NUM_D(i) @property (nonatomic,assign)  double i
#define PRO_NUM_L(i) @property (nonatomic,assign)   long i
#define PRO_NUM_int(i) @property (nonatomic,assign) int i


@interface MKBasic : NSObject


@end
