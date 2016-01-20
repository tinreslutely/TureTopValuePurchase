//
//  MDHttpManager.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/20.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDHttpManager : NSObject

+(void)GET:(NSString*)URLString parameters:(NSDictionary*)params sucessBlock:(void(^)(id  _Nullable responseObject))sucessBlock failureBlock:(void(^)(NSError * _Nonnull error))failureBlock;

+(void)POST:(NSString*)URLString parameters:(NSDictionary*)params sucessBlock:(void(^)(id  _Nullable responseObject))sucessBlock failureBlock:(void(^)(NSError * _Nonnull error))failureBlock;
@end
