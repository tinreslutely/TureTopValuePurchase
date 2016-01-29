//
//  MDFluentDB.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/21.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MDFluentDB : NSObject

@property(nonatomic) sqlite3 *database;

+(instancetype)shareDB;
-(BOOL)executeNonQuery:(NSString*)sql;
-(NSArray*)executeQuery:(NSString*)sql;
-(BOOL)isExistTable:(NSString *)tableName;

@end
