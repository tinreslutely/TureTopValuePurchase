//
//  MDLocationManager.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/11/25.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "MDLocationManager.h"

//@implementation CLLocationManager(TemporaryHack)
//
//-(void)hackLocationFix
//{
//    float longgitude = 113.2759952545166;
//    float latitude = 23.117055306224895;
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longgitude];
//    [[self delegate] locationManager:self didUpdateLocations:@[location]];
//    
//}
//
//-(void)startUpdatingLocation{
//    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//}
//
//@end

@interface MDLocationManager()<CLLocationManagerDelegate>

@end

@implementation MDLocationManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static MDLocationManager *instance;
    dispatch_once(&onceToken,^{
        instance = [[MDLocationManager alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if(self = [super init]){
        [self initLocationManager];
    }
    return self;
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if([manager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                [manager requestAlwaysAuthorization];
                [manager requestWhenInUseAuthorization];
            }
            break;
            
        default:
            break;
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if(locations.count > 0){
        _currentLocation = [locations firstObject];
        if(_currentLocation == nil) return;
        [MDUserDefaultHelper saveForKey:locationLongitudeKey value:[NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude]];
        [MDUserDefaultHelper saveForKey:locationLatitudeKey value:[NSString stringWithFormat:@"%f",_currentLocation.coordinate.latitude]];
    }
    [self stopUpdatingLocation];
    NSLog(@"longitude:%f,latitude:%f",_currentLocation.coordinate.longitude,_currentLocation.coordinate.latitude);
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks > 0){
            _placemark = [placemarks firstObject];
            [MDUserDefaultHelper saveForKey:locationCityKey value:[_placemark locality]];
            for (locationUpdatedBlock block in _successBlockArray) {
                block();
            }
            [_successBlockArray removeAllObjects];
            NSLog(@"定位地址：%@",[_placemark locality]);
        }else{
            for (locationErrorBlock block in _failureBlockArray) {
                block();
            }
            [_failureBlockArray removeAllObjects];
            NSLog(@"定位错误：%@",error);
        }
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self stopUpdatingLocation];
    for (locationErrorBlock block in _failureBlockArray) {
        block();
    }
    [_failureBlockArray removeAllObjects];
    NSLog(@"定位失败，原因是：%@",error);
}
/*! @brief 开始定位
 *
 */
-(void)startUpdatingLocation{
    if(_locationManager == nil){
        [self initLocationManager];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_locationManager startUpdatingLocation];
    });
}

/*! @brief 开始定位
 *
 */
-(void)startUpdatingLocationWithSuccessBlock:(locationUpdatedBlock)successBlock failureBlock:(locationErrorBlock)failureBlock{
    if(_locationManager == nil){
        [self initLocationManager];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_locationManager startUpdatingLocation];
    });
    if(successBlock) [_successBlockArray addObject:successBlock];
    if(failureBlock) [_failureBlockArray addObject:failureBlock];
}

/*! @brief 停止定位
 *
 */
-(void)stopUpdatingLocation{
    if(_locationManager == nil){
        [self initLocationManager];
    }
    [_locationManager stopUpdatingLocation];
}

-(CLPlacemark*)getPlacemark{
    return _placemark;
}

-(void)setLocation:(CLLocation*)location{
    _currentLocation = location;
}
-(CLLocation*)getLocation{
    return _currentLocation;
}

-(void)initLocationManager{
    if(_locationManager == nil){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        _successBlockArray = [[NSMutableArray alloc] init];
        _failureBlockArray = [[NSMutableArray alloc] init];
    }
}

@end
