//
//  MDPersonCenterDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDPersonCenterModel.h"


@interface MDPersonCenterDataController : NSObject

-(void)requestDataWithUserId:(NSString*)userId token:(NSString*)token completion:(void(^)(BOOL state, NSString *msg, MDPersonCenterModel *model))completion;

@end
