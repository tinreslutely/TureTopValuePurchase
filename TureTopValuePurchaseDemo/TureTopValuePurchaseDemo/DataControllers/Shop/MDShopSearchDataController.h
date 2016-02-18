//
//  MDShopSearchDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/18.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDShopSearchModel.h"
@interface MDShopSearchDataController : NSObject

-(void)requestDataWithKeyword:(NSString* _Nullable)keyword shopId:(int)shopId pageNo:(int)pageno pageSize:(int)pagesize completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, NSArray<MDShopSearchModel*>* _Nullable list, int totalCount))completion;

@end
