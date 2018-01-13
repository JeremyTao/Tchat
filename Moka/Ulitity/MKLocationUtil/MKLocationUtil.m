//
//  MKLocationUtil.m
//  Moka
//
//  Created by  moka on 2017/8/4.
//  Copyright © 2017年 moka. All rights reserved.
//

#import "MKLocationUtil.h"
#import <MapKit/MapKit.h>
@interface MKLocationUtil ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D  coordinate2D;
@property (nonatomic, copy)   MKMKLocationUtilBlock updateLocation;
@end

@implementation MKLocationUtil

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"failed" reason:@"do not use init method in this Class, use initWithUpdateLocationBlock" userInfo:nil];
}

- (instancetype)initWithUpdateLocationBlock:(MKMKLocationUtilBlock)updateLocation
{
    self = [super init];
    if (self) {
        // locationManager
        self.locationManager = ({
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            locationManager.distanceFilter = 3000;
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
            locationManager.delegate = self;
            [locationManager startUpdatingLocation];
            locationManager;
        });
        _updateLocation = updateLocation;
    }
    return self;
}

+ (instancetype)locationUtilWithUpdateLocationBlock:(MKMKLocationUtilBlock)updateLocation {
    return [[MKLocationUtil alloc] initWithUpdateLocationBlock:updateLocation];
}

#pragma mark - 更新位置📍
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   
    CLLocation *currentUserLocation = locations.lastObject;
    
    _coordinate2D.latitude = currentUserLocation.coordinate.latitude;
    _coordinate2D.longitude = currentUserLocation.coordinate.longitude;
    _updateLocation(_coordinate2D);
     NSLog(@"----- %f   %f", _coordinate2D.latitude, _coordinate2D.longitude);
    [manager stopUpdatingLocation];
    manager.delegate = nil;
}




@end
