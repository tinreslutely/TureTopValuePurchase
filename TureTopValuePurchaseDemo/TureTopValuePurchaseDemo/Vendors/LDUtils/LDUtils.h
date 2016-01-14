//
//  LDUtils.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDUtils : NSObject

+(void)readDataWithResourceName:(NSString*)resourceName successBlock:(void(^)(NSDictionary*))successBlock failureBlock:(void(^)(LDReadResourceStateType,NSString*))failureBlock;

@end
