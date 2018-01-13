//
//  MKLocationUtil.h
//  Moka
//
//  Created by  moka on 2017/8/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^MKMKLocationUtilBlock)(CLLocationCoordinate2D);

@interface MKLocationUtil : NSObject

+ (instancetype)locationUtilWithUpdateLocationBlock:(MKMKLocationUtilBlock)updateLocation;
- (instancetype)initWithUpdateLocationBlock:(MKMKLocationUtilBlock)updateLocation;

@end
