//
//  MDHomeDataController.m
//  TureTopValuePurchaseDemo
//  首页数据控制器
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeDataController.h"


@implementation MDHomeDataController

#pragma mark public methods
-(void)requestDataWithType:(NSString*)type completion:(void(^)(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel*> *list))completion{
    [MDHttpManager GET:APICONFIG.homeApiURLString parameters:@{@"type":type} sucessBlock:^(id  _Nullable responseObject) {
        MDHomeRenovateModel *renovateModel = [[MDHomeRenovateModel alloc] init];
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if(dic == nil || ![[dic objectForKey:@"state"] isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        renovateModel.stateCode = [dic objectForKey:@"state"];
        renovateModel.state = YES;
        renovateModel.list = [MDHomeRenovateChannelModel mj_objectArrayWithKeyValuesArray:[[dic objectForKey:@"result"] objectForKey:@"list"]];
        for (MDHomeRenovateChannelModel *channelModel in renovateModel.list) {
            channelModel.channelColumnDetails = [MDHomeRenovateChannelDetailModel mj_objectArrayWithKeyValuesArray:channelModel.channelColumnDetails];
        }
        [renovateModel.list sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[NSNumber numberWithInt:[(MDHomeRenovateChannelModel*)obj1 columnType]] compare:[NSNumber numberWithInt:[(MDHomeRenovateChannelModel*)obj2 columnType]]];
        }];
        completion(renovateModel.state,renovateModel.message,renovateModel.list);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

-(void)requestDataWithType:(NSString*)type pageIndex:(int)pageIndex pageSize:(int)pageSize  completion:(void(^)(BOOL state, NSString *msg, NSArray<MDHomeLikeProductModel*> *list))completion{
    [MDHttpManager GET:APICONFIG.homeLikeProductApiURLString parameters:@{@"type":type,@"pageSize":[NSString stringWithFormat:@"%d",pageSize],@"pageIndex":[NSString stringWithFormat:@"%d",pageIndex]} sucessBlock:^(id  _Nullable responseObject) {
        MDHomeLikeProductsModel *productsModel = [[MDHomeLikeProductsModel alloc] init];
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if(dic == nil || ![[dic objectForKey:@"state"] isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        productsModel.stateCode = [dic objectForKey:@"state"];
        productsModel.state = YES;
        productsModel.list = [[NSMutableArray alloc] init];
        NSArray *array = [dic objectForKey:@"result"];
        MDHomeLikeProductModel *model;
        for (NSDictionary *item in array) {
            model = [[MDHomeLikeProductModel alloc] init];
            model.productId = [[item objectForKey:@"id"] intValue];
            model.imageURL = [[[item objectForKey:@"mainPic"] objectForKey:@"shopPic"] objectForKey:@"picAddr"];
            model.sellPirce = [[item objectForKey:@"salesPrice"] doubleValue];
            model.shopId = [[item objectForKey:@"shopId"] intValue];
            model.title = [item objectForKey:@"productName"];
            [productsModel.list addObject:model];
        }
        completion(productsModel.state,nil,productsModel.list);
        
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}


@end
