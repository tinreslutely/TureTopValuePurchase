//
//  MDShopSearchDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/18.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopSearchDataController.h"
#import "MDFluentDB.h"

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


/*!
 *  更新记录
 *
 *  @param keyword 关键字
 *  @param type    搜索类型
 */
-(void)updateRecordWithKeyword:(NSString*)keyword type:(MDSearchType)type completion:(void(^)(BOOL state))completion{
    static NSString *tableName = @"md_search";
    dispatch_queue_t concurrentQueue = dispatch_queue_create("search.concurrent.queue.update", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        if(![[MDFluentDB shareDB] isExistTable:tableName]){
            [[MDFluentDB shareDB] executeNonQuery:[NSString stringWithFormat:@"CREATE TABLE %@ (id integer PRIMARY KEY AUTOINCREMENT,keyword text,type integer,datetime text) ",tableName]];
        }
        NSString *sql = @"";
        if([[MDFluentDB shareDB] executeQuery:[NSString stringWithFormat:@"select * from %@ where keyword='%@' and type='%d' order by datetime desc;",tableName, keyword, (int)type]].count > 0){
            sql = [NSString stringWithFormat:@"update %@ set datetime='%@' where keyword='%@' and type='%d'",tableName,[NSDate date],keyword,(int)type];
        }else{
            sql = [NSString stringWithFormat:@"insert into %@ (keyword,type,datetime) values('%@','%d','%@')",tableName,keyword,(int)type,[NSDate date]];
        }
        BOOL state = [[MDFluentDB shareDB] executeNonQuery:sql];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) completion(state);
        });
    });
}


@end
