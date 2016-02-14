//
//  MDMemberDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMemberInfomationModel.h"
@interface MDMemberDataController : NSObject
-(void)requestDataWithUserId:(NSString*)userId token:(NSString*)token completion:(void(^)(BOOL state, NSString *msg,  MDMemberInfomationModel *model))completion;
@end
