//
//  MDMessageDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/4.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMessageDataController.h"

@implementation MDMessageDataController

/*!
 *  消息、通知、公告列表
 *
 *  @param userId      用户id
 *  @param pageNo      当前页
 *  @param pageSize    每页显示条数
 *  @param messageType 信息类型(1-消息，2-通知  3-公告)
 *  @param completion  回调函数
 */
-(void)requestDataWithUserId:(NSString*)userId pageNo:(int)pageNo pageSize:(int)pageSize messageType:(MDMessageType)messageType completion:(void(^)(BOOL state, NSString *msg, NSArray<MDMessageModel*> *list))completion{
    NSString *url = @"";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"userId":userId,@"pageNo":[NSString stringWithFormat:@"%d",pageNo],@"pageSize":[NSString stringWithFormat:@"%d",pageSize]} ];
    switch (messageType) {
        case MDMessageTypeMessage:
            url = APICONFIG.normalMessageApiURLString;
            break;
        case MDMessageTypeNotify:
            url = APICONFIG.normalNotifyApiURLString;
            [dic setObject:@"0" forKey:@"type"];
            break;
        case MDMessageTypeTrends:
            url = APICONFIG.normalNotifyApiURLString;
            [dic setObject:@"1" forKey:@"type"];
            break;
    }
    [MDHttpManager GET:url parameters:dic sucessBlock:^(id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *stateCode = [dic objectForKey:@"state"];
        if(dic == nil || ![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        BOOL state = YES;
        NSArray<MDMessageModel*> *list = [MDMessageModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"result"]];
        completion(state,nil,list);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  消息、通知、公告详情
 *
 *  @param messageId   信息id
 *  @param messageType 信息类型(1-消息，2-通知  3-公告)
 *  @param completion  回调函数
 */
-(void)requestDetailDataWithMessageId:(NSString* _Nullable)messageId messageType:(MDMessageType)messageType  completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDMessageModel*  _Nullable model))completion{
    [MDHttpManager GET:(messageType == MDMessageTypeMessage ? APICONFIG.normalMessageDetailApiURLString : APICONFIG.normalNotifyDetailApiURLString) parameters:@{@"id":messageId} sucessBlock:^(id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *stateCode = [dic objectForKey:@"state"];
        if(dic == nil || ![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        BOOL state = YES;
        MDMessageModel *model = [MDMessageModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        completion(state,nil,model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}



/*!
 *  获取未读消息总条数
 *
 *  @param userId     用户id
 *  @param completion 回调函数 messageNum-消息数量  noticeNum-通知数量  dtNum-动态数量
 */
-(void)requestUnreadDataWithUserId:(NSString* _Nullable)userId completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, int messageNum, int noticeNum, int dtNum))completion{
    [MDHttpManager GET:APICONFIG.noReadNumberMessageApiURLString parameters:@{@"userId":userId} sucessBlock:^(id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *stateCode = [dic objectForKey:@"state"];
        if(dic == nil || ![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],0 ,0 ,0);
            return;
        }
        NSDictionary *result = [dic objectForKey:@"result"];
        int messageNum = [[result objectForKey:@"messageNum"] intValue];
        int noticeNum = [[result objectForKey:@"noticeNum"] intValue];
        int dtNum = [[result objectForKey:@"dtNum"] intValue];
        completion(YES,nil,messageNum,noticeNum,dtNum);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO, [NSString stringWithFormat:@"%@",error] ,0 ,0 ,0);
    }];
}

/*!
 *  修改消息的未读状态为已读状态
 *
 *  @param messageId      消息id
 *  @param completion  回调函数
 */
-(void)markReadStateDataWithUserId:(NSString* _Nullable)userId messageId:(NSString* _Nullable)messageId messageType:(MDMessageType)messageType completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion{
    [MDHttpManager POST:(messageType == MDMessageTypeMessage ? APICONFIG.markReadMessageApiURLString : APICONFIG.markReadNotifyApiURLString) parameters:@{@"userId":userId, @"ids":messageId} sucessBlock:^(id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *stateCode = [dic objectForKey:@"state"];
        if(dic == nil || ![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"]);
            return;
        }
        NSDictionary *result = [dic objectForKey:@"result"];
        completion([[result objectForKey:@"flag"] boolValue],[result objectForKey:@"Info"]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO, [NSString stringWithFormat:@"%@",error]);
    }];
}

/*!
 *  删除指定的消息
 *
 *  @param messageId      消息id
 *  @param completion  回调函数
 */
-(void)removeDataWithUserId:(NSString* _Nullable)userId Id:(NSString* _Nullable)messageId  messageType:(MDMessageType)messageType completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion{
    [MDHttpManager POST:(messageType == MDMessageTypeMessage ? APICONFIG.removeMessageDetailApiURLString : APICONFIG.removeNotifyDetailApiURLString) parameters:@{@"userId":userId, @"ids":messageId} sucessBlock:^(id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *stateCode = [dic objectForKey:@"state"];
        if(dic == nil || ![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"]);
            return;
        }
        NSDictionary *result = [dic objectForKey:@"result"];
        completion([[result objectForKey:@"flag"] boolValue],[result objectForKey:@"Info"]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO, [NSString stringWithFormat:@"%@",error]);
    }];
}

@end
