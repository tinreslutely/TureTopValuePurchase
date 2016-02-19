//
//  MDGoodsDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/2.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDGoodsModel.h"

@interface MDGoodsDataController : NSObject

-(void)requestDataWithPageNo:(int)pageno pageSize:(int)pagesize keywords:(NSString*)keywords categoryId:(int)categoryId shopId:(int)shopId productType:(NSString*)productType sort:(int)sort completion:(void(^)(BOOL state, NSString *msg, NSArray<MDGoodsModel*> *list,int totalPage))completion;
-(void)updateRecordWithKeyword:(NSString*)keyword type:(MDSearchType)type completion:(void(^)(BOOL state))completion;
@end
