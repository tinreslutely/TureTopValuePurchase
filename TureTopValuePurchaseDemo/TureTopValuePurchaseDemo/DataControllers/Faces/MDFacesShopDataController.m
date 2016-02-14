//
//  MDFacesShopDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/8.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDFacesShopDataController.h"

@implementation MDFacesShopDataController

/**
 *  根据请求的参数条件，获取面对面支付店铺列表数据
 *  userId、page、pagesize这三个参数是必传
 *  其余参数可选 ，字符串类型传空值或null值、基本类型传-1为不加入该参数查询
 *
 *  @param shopName       店铺名称
 *  @param city           店铺所在的城市
 *  @param street         店铺所在城市街道code
 *  @param orderby        排序条件   distance  最近距离  return_down  降序   return_up  升序
 *  @param industry       行业id
 *  @param parentIndustry 父行业id
 *  @param userLat        经度
 *  @param userLng        纬度
 *  @param userId         用户id
 *  @param page           当前页
 *  @param pagesize       页显示数量
 */
-(void)requestDataWithShopName:(NSString*)shopName city:(NSString*)city street:(NSString*)street orderBy:(NSString*)orderby industry:(int)industry parentIndustry:(int)parentIndustry userLat:(double)userLat userLng:(double)userLng userId:(int)userId page:(int)page pageSize:(int)pagesize completion:(void(^)(BOOL state, NSString *msg, NSArray<MDFacesShopModel*> *list,int totalPage))completion{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"condition.userId":[NSString stringWithFormat:@"%d",userId],@"condition.page":[NSString stringWithFormat:@"%d",page],@"condition.pageSize":[NSString stringWithFormat:@"%d",pagesize]}];
    if(shopName != nil && ![shopName isEqualToString:@""]) [dic setObject:shopName forKey:@"condition.shopName"];
    if(city != nil && ![city isEqualToString:@""]) [dic setObject:city forKey:@"condition.city"];
    if(street != nil && ![street isEqualToString:@""]) [dic setObject:street forKey:@"condition.street"];
    if(orderby != nil && ![orderby isEqualToString:@""]) [dic setObject:orderby forKey:@"condition.orderBy"];
    if(industry != -1) [dic setObject:[NSString stringWithFormat:@"%d",industry] forKey:@"condition.industry"];
    if(parentIndustry != -1) [dic setObject:[NSString stringWithFormat:@"%d",parentIndustry] forKey:@"condition.parentIndustry"];
    if(userLat != -1) [dic setObject:[NSString stringWithFormat:@"%f",userLat] forKey:@"condition.userLat"];
    if(userLng != -1) [dic setObject:[NSString stringWithFormat:@"%f",userLng] forKey:@"condition.userLng"];
    
    [MDHttpManager GET:APICONFIG.facesPayShopApiURLString parameters:dic sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil,0);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil,0);
            return;
        }
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray<MDFacesShopModel*> *list = [MDFacesShopModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
        completion(YES, nil, list, [[result objectForKey:@"totalPages"] intValue]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil,0);
    }];
}

-(void)requestCategoryDataWithParentTypeId:(int)pid completion:(void(^)(BOOL state, NSString *msg, NSArray<MDFacesShopCategoryModel*> *list))completion{
    [MDHttpManager GET:APICONFIG.facesPayCategoriesApiURLString parameters:@{@"pid":[NSString stringWithFormat:@"%d",pid]} sucessBlock:^(id  _Nullable responseObject) {
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
        NSArray<MDFacesShopCategoryModel*> *list = [MDFacesShopCategoryModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"result"]];
        completion(YES, nil, list);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/**
 *  通过可选参数获取面对面店铺城市区域列表数据
 *  参数都为可选 ，字符串类型传空值或null值、基本类型传-1为不加入该参数查询
 *
 *  @param city  城市
 *  @param lng   经纬度
 *  @param lat   经纬度
 *  @param completion 完成回调
 */
-(void)requestAreaDataWithCity:(NSString*)city lng:(double)lng lat:(double)lat completion:(void(^)(BOOL state, NSString *msg, NSString *parentCode, NSString *city, NSArray<MDFacesShopAreaModel*> *list))completion{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(city != nil && ![city isEqualToString:@""]) [dic setObject:city forKey:@"city"];
    if(lng != -1) [dic setObject:[NSString stringWithFormat:@"%f",lng] forKey:@"lng"];
    if(lat != -1) [dic setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
    [MDHttpManager POST:APICONFIG.facesPayCitiesApiURLString parameters:dic sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error], nil, nil, nil);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"], nil, nil, nil);
            return;
        }
        
        NSDictionary *result = [dic objectForKey:@"result"];
        NSString *parentCode = [result objectForKey:@"parentCode"];
        NSString *city = [result objectForKey:@"city"];
        NSArray<MDFacesShopAreaModel*> *list = [MDFacesShopAreaModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"list"]];
        completion(YES, nil, parentCode, city, list);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error], nil, nil, nil);
    }];
}

/**
 *  根据地区编号请求街道列表数据
 *
 *  @param code  地区编号
 *  @param completion 完成回调方法
 */
-(void)requestStreetDataWithCode:(NSString*)code completion:(void(^)(BOOL state, NSString *msg, NSArray<MDFacesShopStreetModel*> *list))completion{
    [MDHttpManager GET:APICONFIG.facesPayStreetShopApiURLString parameters:@{@"code":code} sucessBlock:^(id  _Nullable responseObject) {
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
        NSArray<MDFacesShopStreetModel*> *list = [MDFacesShopStreetModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"result"]];
        completion(YES, nil, list);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}
@end
