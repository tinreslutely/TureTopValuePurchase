//
//  MDClassesDataController.m
//  TureTopValuePurchaseDemo
//  产品类目数据控制器
//  Created by 李晓毅 on 16/1/23.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDClassesDataController.h"

@implementation MDClassesDataController

/*!
 *  获取一级类目数据
 *
 *  @param completion block函数
 */
-(void)requestFirstDataWithCompletion:(void(^)(BOOL state, NSString *msg, NSArray<MDClassesModel*> *list))completion{
    [MDHttpManager GET:APICONFIG.categoriesApiURLString parameters:@{} sucessBlock:^(id  _Nullable responseObject) {
        [self convertData:responseObject completion:completion];
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  获取二级类目数据
 *
 *  @param typeId     一级类目id
 *  @param cType      类目类型 0:超值购,1:天天特卖,2:热卖,3:小平台类目
 *  @param completion block函数
 */
-(void)requestSecondDataWithTypeId:(int)typeId cType:(int)cType completion:(void(^)(BOOL state, NSString *msg, NSArray<MDClassesModel*> *list))completion{
    [MDHttpManager GET:APICONFIG.secondCategoriesApiURLString parameters:@{@"typeId":[NSString stringWithFormat:@"%d",typeId],@"cType":[NSString stringWithFormat:@"%d",cType]} sucessBlock:^(id  _Nullable responseObject) {
        [self convertData:responseObject completion:completion];
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  转换数据
 *
 *  @param responseObject 需转换的数据对象
 *  @param completion     block函数
 */
-(void)convertData:(id)responseObject completion:(void(^)(BOOL state, NSString *msg, NSArray<MDClassesModel*> *list))completion{
    NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    if(dic == nil){
        completion(NO,@"返回数据有误",nil);
        return;
    }
    NSString *stateCode = [dic objectForKey:@"state"];
    BOOL state = [stateCode isEqualToString:@"200"];
    if(!state){
        completion(NO,[dic objectForKey:@"result"],nil);
        return ;
    }
    NSArray *firstTypes = [[dic objectForKey:@"result"] objectForKey:@"firstTypes"];
    if(firstTypes != nil){
        completion(YES,nil,[MDClassesModel mj_objectArrayWithKeyValuesArray:firstTypes]);
        return;
    }
    NSArray *secondTypes = [[dic objectForKey:@"result"] objectForKey:@"list"];
    if(secondTypes != nil){
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        NSArray *array;
        MDClassesModel *model;
        for (NSDictionary *itemDic in secondTypes) {
            model = [[MDClassesModel alloc ] init];
            array = [MDClassesModel mj_objectArrayWithKeyValuesArray:[itemDic objectForKey:@"secondTypes" ]];
            model = [MDClassesModel mj_objectWithKeyValues:itemDic];
            model.secondTypes = array;
            [categories addObject:model];
        }
        completion(YES,nil,categories);
        return;
    }
}
@end
