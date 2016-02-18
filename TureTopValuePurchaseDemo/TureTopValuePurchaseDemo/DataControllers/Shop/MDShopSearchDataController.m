//
//  MDShopSearchDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/18.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopSearchDataController.h"

@implementation MDShopSearchDataController

/*!
 *  店铺搜索请求数据
 *
 *  @param keyword  关键词
 *  @param shopId   店铺编码
 *  @param pageno   当前页
 *  @param pagesize 页显示记录数
 */
-(void)requestDataWithKeyword:(NSString* _Nullable)keyword shopId:(int)shopId pageNo:(int)pageno pageSize:(int)pagesize completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, NSArray<MDShopSearchModel*>* _Nullable list, int totalCount))completion{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"page.pageNo",[NSString stringWithFormat:@"%d",pagesize],@"page.pageSize", nil];
    if(keyword != nil && ![keyword isEqualToString:@""]) [dic setObject:keyword forKey:@"cond.keyWords"];
    if(shopId != -1) [dic setObject:[NSString stringWithFormat:@"%d",shopId] forKey:@"cond.shopId"];
    
    [MDHttpManager GET:APICONFIG.shopSearchApiURLString parameters:dic sucessBlock:^(id  _Nullable responseObject) {
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
        int totalCount = [[result objectForKey:@"totalCount"] intValue];
        NSArray<MDShopSearchModel*> *list = [MDShopSearchModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
        completion(YES, nil, list, totalCount);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil,0);
    }];
}


@end
