//
//  MDLocationManager.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/11/25.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MDLocationManager : NSObject


@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLPlacemark *placemark;
@property(nonatomic,strong) CLLocation *currentLocation;
@property(nonatomic,strong) NSMutableArray *successBlockArray;
@property(nonatomic,strong) NSMutableArray *failureBlockArray;


+(instancetype)sharedManager;
-(void)startUpdatingLocation;
-(void)startUpdatingLocationWithSuccessBlock:(locationUpdatedBlock)successBlock failureBlock:(locationErrorBlock)failureBlock;
-(void)stopUpdatingLocation;
-(CLPlacemark*)getPlacemark;
-(void)setLocation:(CLLocation*)location;
-(CLLocation*)getLocation;
@end
