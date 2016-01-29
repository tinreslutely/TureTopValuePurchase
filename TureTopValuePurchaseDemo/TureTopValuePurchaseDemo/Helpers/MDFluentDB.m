//
//  MDFluentDB.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/21.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDFluentDB.h"

#ifndef MDDatabaseName
#define MDDatabaseName @"mdczg.db"
#endif

@implementation MDFluentDB

+(instancetype)shareDB{
    static dispatch_once_t onceToken;
    static MDFluentDB *fluentDB;
    dispatch_once(&onceToken, ^{
        fluentDB = [[MDFluentDB alloc] init];
    });
    return fluentDB;
}

#pragma mark public methods

/*!
 *  根据sql语句查询数据库
 *  用于查询
 *
 *  @param sql 执行的sql语句
 *
 *  @return 结果集
 */
-(NSArray*)executeQuery:(NSString*)sql{
    if(!_database && ![self openDb:MDDatabaseName]){
        return nil;
    }
    NSMutableArray *rows=[NSMutableArray array];//数据行
    //评估语法正确性
    sqlite3_stmt *stmt;
    //检查语法正确性
    if (SQLITE_OK==sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL)) {
        //单步执行sql语句
        while (SQLITE_ROW==sqlite3_step(stmt)) {
            int columnCount= sqlite3_column_count(stmt);
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for (int i=0; i<columnCount; i++) {
                const char *name= sqlite3_column_name(stmt, i);//取得列名
                const unsigned char *value= sqlite3_column_text(stmt, i);//取得某列的值
                dic[[NSString stringWithUTF8String:name]]=[NSString stringWithUTF8String:(const char *)value];
            }
            [rows addObject:dic];
        }
    }
    //释放句柄
    sqlite3_finalize(stmt);
    return rows;
}

/*!
 * 在数据库中执行sql
 * 用于新增、更新、删除
 *
 *  @param sql 执行的sql语句
 *
 *  @return 是否执行成功
 */
-(BOOL)executeNonQuery:(NSString*)sql{
    if(!_database && ![self openDb:MDDatabaseName]){
        return NO;
    }
    char *error;
    if(SQLITE_OK != sqlite3_exec(_database, sql.UTF8String, NULL, NULL, &error)){
        return NO;
    }
    return YES;
}

-(BOOL)isExistTable:(NSString *)tableName{
    if(!_database && ![self openDb:MDDatabaseName]){
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"select count(*) as count from sqlite_master where type='table' and name='%@';",tableName];
    int count = 0;
    sqlite3_stmt *sql_stmt;
    if(sqlite3_prepare_v2(_database, [sql UTF8String], -1, &sql_stmt, nil) == SQLITE_OK){
        while(sqlite3_step(sql_stmt)==SQLITE_ROW){
            count = sqlite3_column_int(sql_stmt, 0);
        }
        sqlite3_finalize(sql_stmt);
    }
    return count == 1;
}

#pragma mark private methods
/*!
 *  打开指定的数据库
 *
 *  @param dbname 数据库名
 *
 *  @return 是否成功打开
 */
-(BOOL)openDb:(NSString *)dbname{
    //取得数据库保存路径，通常保存沙盒Documents目录
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath=[path stringByAppendingPathComponent:dbname];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //如果有数据库则直接打开，否则创建并打开（注意filePath是ObjC中的字符串，需要转化为C语言字符串类型）
    if (SQLITE_OK != sqlite3_open(filePath.UTF8String, &_database)) {
        sqlite3_close(_database);
        return NO;
    }
    return YES;
}


@end
