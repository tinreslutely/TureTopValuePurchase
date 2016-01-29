//
//  MDShopDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/25.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDShopModel.h"

@interface MDShopDataController : NSObject

-(void)requestDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, MDShopModel *model))completion;

-(void)requestInformationDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, MDShopInformationModel *model))completion;
@end
