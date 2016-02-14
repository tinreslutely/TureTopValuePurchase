//
//  MDHomeDataController.h
//  TureTopValuePurchaseDemo
//  首页数据控制器
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDHomeModel.h"

#import "SDCycleScrollView.h"

@interface MDHomeDataController : NSObject

-(void)requestDataWithType:(NSString*)type completion:(void(^)(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel*> *list))completion;
-(void)requestDataWithType:(NSString*)type pageIndex:(int)pageIndex pageSize:(int)pageSize  completion:(void(^)(BOOL state, NSString *msg, NSArray<MDHomeLikeProductModel*> *list))completion;
-(void)requestTotalDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, int total))completion;
@end
