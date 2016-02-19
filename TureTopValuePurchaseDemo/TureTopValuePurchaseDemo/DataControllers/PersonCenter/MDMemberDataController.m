//
//  MDMemberDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMemberDataController.h"

@implementation MDMemberDataController
-(void)requestDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token completion:(void(^ _Nullable)(BOOL state, NSString*  _Nullable msg,  MDMemberInfomationModel* _Nullable model))completion{
    [MDHttpManager GET:APICONFIG.memberInfoApiURLString parameters:@{@"userId":userId,@"token":token} sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        MDMemberInfomationModel *model = [MDMemberInfomationModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        completion(YES,nil,model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  上传用户头像，上传成功后修改用户头像信息
 *
 *  @param image      头像图片
 *  @param userId     用户id
 *  @param token      用户token
 *  @param name       字段名
 *  @param completion 完成回调
 */
-(void)uploadImageWithImage:(UIImage* _Nullable)image userId:(NSString* _Nullable)userId token:(NSString* _Nullable)token name:(NSString* _Nullable)name  completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDUploadPicModel*  _Nullable model))completion{
    [MDHttpManager POST:APICONFIG.uploadPicApiURLString parameters:@{} image:image sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil);
            return;
        }
        int stateCode = [[dic objectForKey:@"error"] intValue];
        if(stateCode != 0){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        MDUploadPicModel *model = [MDUploadPicModel mj_objectWithKeyValues:dic];
        [self submitMemberInformationDataWithUserId:userId token:token name:name value:model.relativeUrl completion:^(BOOL state, NSString *msg) {
            if(state) completion(YES,nil,model);
        }];
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  提交修改用户会员指定的信息
 *
 *  @param userId     用户id
 *  @param token      用户token
 *  @param name       字段名
 *  @param value      值
 *  @param completion 完成回调
 */
-(void)submitMemberInformationDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token name:(NSString* _Nullable)name value:(NSString* _Nullable)value completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion{
    [MDHttpManager POST:APICONFIG.alterMemerInfoApiURLString parameters:@{@"userId":userId, @"token":token, name:value} sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error]);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"]);
            return;
        }
        completion(YES,nil);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error]);
    }];
}

/*!
 *  提交修改用户地区信息
 *
 *  @param userId     用户id
 *  @param token      用户token
 *  @param province   省份
 *  @param city       城市
 *  @param district   县区
 *  @param completion 完成回调
 */
-(void)submitMemberAreaDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token province:(NSString* _Nullable)province city:(NSString* _Nullable)city district:(NSString* _Nullable)district completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion{
    [MDHttpManager POST:APICONFIG.alterMemerInfoApiURLString parameters:@{@"userId":userId,@"token":token,@"province":province,@"city":city,@"county":district} sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error]);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"]);
            return;
        }
        completion(YES,nil);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error]);
    }];
}
@end
