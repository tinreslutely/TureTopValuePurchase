//
//  MDCartDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/25.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDCartDataController.h"

@implementation MDCartDataController

-(void)requestDataWithUserId:(NSString*)userId completion:(void(^)(BOOL state, NSString *msg, NSArray<MDCartShopModel*> *list))completion{
    [MDHttpManager GET:APICONFIG.cartApiURLString parameters:@{@"userId":userId} sucessBlock:^(id  _Nullable responseObject) {
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
        NSArray *list = [MDCartShopModel mj_objectArrayWithKeyValuesArray:[[dic objectForKey:@"result"] objectForKey:@"cart"]];
        for (MDCartShopModel *model in list) {
            model.products = [MDCartModel mj_objectArrayWithKeyValuesArray:model.products];
        }
        completion(YES,nil,list);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}


-(void)alertCartNumberWithCartId:(NSString*)cartId quantity:(NSString*)quantity  completion:(void(^)(BOOL state, NSString *msg))completion{
    [MDHttpManager POST:APICONFIG.cartAlertProductApiURLString parameters:@{@"cartId":cartId,@"qty":quantity} sucessBlock:^(id  _Nullable responseObject) {
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
        completion(YES,[dic objectForKey:@"result"]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error]);
    }];
}


-(void)removeCartWithCartId:(NSString*)cartId completion:(void(^)(BOOL state, NSString *msg))completion{
    [MDHttpManager POST:APICONFIG.cartRemoveProductApiURLString parameters:@{@"cartIds":cartId} sucessBlock:^(id  _Nullable responseObject) {
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
        completion(YES,[dic objectForKey:@"result"]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error]);
    }];
}

@end
