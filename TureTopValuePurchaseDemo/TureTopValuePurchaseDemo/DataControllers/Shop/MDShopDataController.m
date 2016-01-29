//
//  MDShopDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/25.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopDataController.h"

@implementation MDShopDataController
-(void)requestDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, MDShopModel *model))completion{
    [MDHttpManager GET:APICONFIG.shopConciseInformationApiURLString parameters:@{@"userId":userId} sucessBlock:^(id  _Nullable responseObject) {
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
        completion(YES,nil,[MDShopModel mj_objectWithKeyValues:[dic objectForKey:@"result"]]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

-(void)requestInformationDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, MDShopInformationModel *model))completion{
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
        completion(YES,nil,[MDShopInformationModel mj_objectWithKeyValues:[dic objectForKey:@"result"]]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

@end
