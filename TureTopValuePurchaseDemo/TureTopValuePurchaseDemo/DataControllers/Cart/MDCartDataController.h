//
//  MDCartDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/25.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDCartModel.h"

@interface MDCartDataController : NSObject

-(void)requestDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, NSArray<MDCartShopModel*> *list))completion;
-(void)alertCartNumberWithCartId:(NSString*)cartId quantity:(NSString*)quantity  completion:(void(^)(BOOL state, NSString *msg))completion;
-(void)removeCartWithCartId:(NSString*)cartId completion:(void(^)(BOOL state, NSString *msg))completion;

@end
