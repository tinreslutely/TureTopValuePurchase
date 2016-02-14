//
//  MDMessageDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/4.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMessageModel.h"

@interface MDMessageDataController : NSObject

-(void)requestDataWithUserId:(NSString*)userId pageNo:(int)pageNo pageSize:(int)pageSize messageType:(int)messageType completion:(void(^)(BOOL state, NSString *msg, NSArray<MDMessageModel*> *list))completion;
-(void)requestDetailDataWithMessageId:(NSString*)messageId messageType:(int)messageType  completion:(void(^)(BOOL state, NSString *msg, MDMessageModel *model))completion;
-(void)requestUnreadDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, int messageNum, int noticeNum, int dtNum))completion;
-(void)markReadStateDataWithMessageId:(NSString*)messageId messageType:(int)messageType completion:(void(^)(BOOL state, NSString *msg))completion;
-(void)removeDataWithUserId:(NSString*)userId Id:(NSString*)messageId  messageType:(int)messageType completion:(void(^)(BOOL state, NSString *msg))completion;
@end
