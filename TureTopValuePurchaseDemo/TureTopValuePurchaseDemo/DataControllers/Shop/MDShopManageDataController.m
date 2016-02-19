//
//  MDShopManageDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/17.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopManageDataController.h"

@implementation MDShopManageDataController

/**
 *  获取店铺详细的数据
 *
 *  @param userId 用户ID
 *  @param block  成功回调函数
 */
-(void)requestDataWithUserId:(NSString* _Nullable)userId completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDShopInformationModel*  _Nullable model))completion{
    [MDHttpManager GET:APICONFIG.shopDetailApiURLString parameters:@{@"userId":userId} sucessBlock:^(id  _Nullable responseObject) {
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
        MDShopInformationModel *model = [MDShopInformationModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
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
 *  @param completion 完成回调
 */
-(void)uploadImageWithImage:(UIImage* _Nullable)image userId:(NSString* _Nullable)userId token:(NSString* _Nullable)token completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDUploadPicModel*  _Nullable model))completion{
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
        completion(YES,nil,model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

-(void)submitShopInformationDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token shopNavigationPic:(NSString* _Nullable) shopNavigationPic shopLogo:(NSString* _Nullable)shopLogo shopName:(NSString* _Nullable)shopName businessHours:(NSString* _Nullable)businessHours serviceQq:(NSString* _Nullable)serviceQq serviceTel:(NSString* _Nullable)serviceTel street:(NSString* _Nullable)street isModified:(int)isModified area:(NSString* _Nullable)area completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion{
    NSDictionary *dic = @{
                          @"userId":userId,
                          @"token":token,
                          @"shopInfo.shopNavigationPic":shopNavigationPic,
                          @"shopInfo.shopLogo":shopLogo,
                          @"shopInfo.shopName":shopName,
                          @"shopInfo.businessHours":businessHours,
                          @"shopInfo.serviceQq":serviceQq,
                          @"shopInfo.serviceTel":serviceTel,
                          @"shopInfo.street":street,
                          @"shopInfo.isModified":[NSString stringWithFormat: @"%d",isModified],
                          @"area":area
                          };
    [MDHttpManager POST:APICONFIG.alterShopInfoApiURLString parameters:dic sucessBlock:^(id  _Nullable responseObject) {
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
