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

-(void)requestDataWithUserId:(NSString* _Nullable)userId pageNo:(int)pageNo pageSize:(int)pageSize messageType:(MDMessageType)messageType completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, NSArray<MDMessageModel*>* _Nullable list))completion;
-(void)requestDetailDataWithMessageId:(NSString* _Nullable)messageId messageType:(MDMessageType)messageType  completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDMessageModel*  _Nullable model))completion;
-(void)requestUnreadDataWithUserId:(NSString* _Nullable)userId completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, int messageNum, int noticeNum, int dtNum))completion;
-(void)markReadStateDataWithUserId:(NSString* _Nullable)userId messageId:(NSString* _Nullable)messageId messageType:(MDMessageType)messageType completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion;
-(void)removeDataWithUserId:(NSString* _Nullable)userId Id:(NSString* _Nullable)messageId  messageType:(MDMessageType)messageType completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion;
@end
