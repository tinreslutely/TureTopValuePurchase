//
//  MDFacesShopDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/8.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDFacesShopModel.h"
#import "MDFacesShopAreaModel.h"
#import "MDFacesShopCategoryModel.h"
#import "MDFacesShopStreetModel.h"

@interface MDFacesShopDataController : NSObject

-(void)requestDataWithShopName:(NSString*)shopName city:(NSString*)city street:(NSString*)street orderBy:(NSString*)orderby industry:(int)industry parentIndustry:(int)parentIndustry userLat:(double)userLat userLng:(double)userLng userId:(int)userId page:(int)page pageSize:(int)pagesize completion:(void(^)(BOOL state, NSString *msg, NSArray<MDFacesShopModel*> *list,int totalPage))completion;

-(void)requestCategoryDataWithParentTypeId:(int)pid completion:(void(^)(BOOL state, NSString *msg, NSArray<MDFacesShopCategoryModel*> *list))completion;

-(void)requestAreaDataWithCity:(NSString*)city lng:(double)lng lat:(double)lat completion:(void(^)(BOOL state, NSString *msg, NSString *parentCode, NSString *city, NSArray<MDFacesShopAreaModel*> *list))completion;

-(void)requestStreetDataWithCode:(NSString*)code completion:(void(^)(BOOL state, NSString *msg, NSArray<MDFacesShopStreetModel*> *list))completion;
@end
