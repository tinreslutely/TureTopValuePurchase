//
//  MDAppData.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/21.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDAppData.h"

@implementation MDAppData

@synthesize userId,userCode,userName,phone,token,headPortrait,nickName,area,cartTotal,userGrade,locationCity,locationLatitude,locationLongitude,appFunctionType,mergeCode,networkStatus;

+(instancetype)sharedData{
    static MDAppData *appData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appData = [[MDAppData alloc] init];
        appData.appFunctionType = @"0";
        appData.networkStatus = 1;
    });
    return appData;
}
@end
