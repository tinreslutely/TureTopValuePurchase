//
//  MDGoodsDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/2.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDGoodsDataController.h"

@implementation MDGoodsDataController

-(void)requestDataWithPageNo:(int)pageno pageSize:(int)pagesize keywords:(NSString*)keywords categoryId:(int)categoryId shopId:(int)shopId productType:(NSString*)productType sort:(int)sort completion:(void(^)(BOOL state, NSString *msg, NSArray<MDGoodsModel*> *list,int totalPage))completion{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"page.pageNo":[NSString stringWithFormat:@"%d",pageno],
                                                                                 @"page.pageSize":[NSString stringWithFormat:@"%d",pagesize],
                                                                                 @"prodCond.productType":productType}];
    if(keywords != nil && ![keywords isEqualToString:@""]) [dic setObject:keywords forKey:@"prodCond.keyWords"];
    if(shopId != -1) [dic setObject:[NSString stringWithFormat:@"%d",shopId] forKey:@"shopId"];
    if(categoryId != -1) [dic setObject:[NSString stringWithFormat:@"%d",categoryId] forKey:@"prodCond.categoryId"];
    if(sort != -1) [dic setObject:[NSString stringWithFormat:@"%d",sort] forKey:@"sort"];
    [MDHttpManager GET:APICONFIG.productSearchApiURLString parameters:dic sucessBlock:^(id  _Nullable responseObject) {
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
        NSArray<MDGoodsModel*> *list = [MDGoodsModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
        completion(YES, nil, list, [[result objectForKey:@"totalPages"] intValue]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil,0);
    }];
}

@end
