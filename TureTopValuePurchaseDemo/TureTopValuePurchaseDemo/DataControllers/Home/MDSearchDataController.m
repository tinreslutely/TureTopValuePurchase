//
//  MDSearchDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/28.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDSearchDataController.h"
#import "MDFluentDB.h"

@implementation MDSearchDataController

/*!
 *  查询所有历史记录
 *
 *  @param type 搜索类型
 *
 *  @return 结果集
 */
-(void)selectAllRecordWithType:(MDSearchType)type completion:(void(^)(NSArray *array))completion{
    static NSString *tableName = @"md_search";
    dispatch_queue_t concurrentQueue = dispatch_queue_create("search.concurrent.queue.select", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSArray *result = [[MDFluentDB shareDB] executeQuery:[NSString stringWithFormat:@"select * from %@ where type='%d' order by datetime desc;",tableName,(int)type]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) completion(result.count > 0 ? [MDSearchModel mj_objectArrayWithKeyValuesArray:result] : result);
        });
    });
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

/*!
 *  删除指定的数据
 *
 *  @param keyword 关键字
 *  @param type    搜索类型
 */
-(void)deleteRecordWithKeyword:(NSString*)keyword type:(MDSearchType)type completion:(void(^)(BOOL state))completion{
    static NSString *tableName = @"md_search";
    dispatch_queue_t concurrentQueue = dispatch_queue_create("search.concurrent.queue.delete", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        BOOL state = [[MDFluentDB shareDB] executeNonQuery:[NSString stringWithFormat:@"delete from %@ where keyword='%@' and type='%d'", tableName, keyword, (int)type]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) completion(state);
        });
    });
}

/*!
 *  删除所有数据
 *
 *  @param type 搜索类型
 */
-(void)deleteAllRecordWithType:(MDSearchType)type completion:(void(^)(BOOL state))completion{
    static NSString *tableName = @"md_search";
    dispatch_queue_t concurrentQueue = dispatch_queue_create("search.concurrent.queue.delete", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        BOOL state = [[MDFluentDB shareDB] executeNonQuery:[NSString stringWithFormat:@"delete from %@ where type='%d'",tableName,(int)type]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) completion(state);
        });
    });
}

@end
