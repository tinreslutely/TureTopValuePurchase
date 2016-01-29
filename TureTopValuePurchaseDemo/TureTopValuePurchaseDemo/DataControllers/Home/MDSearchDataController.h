//
//  MDSearchDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/28.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDSearchModel.h"

@interface MDSearchDataController : NSObject

-(void)selectAllRecordWithType:(MDSearchType)type completion:(void(^)(NSArray *array))completion;
-(void)updateRecordWithKeyword:(NSString*)keyword type:(MDSearchType)type completion:(void(^)(BOOL state))completion;
-(void)deleteRecordWithKeyword:(NSString*)keyword type:(MDSearchType)type completion:(void(^)(BOOL state))completion;
-(void)deleteAllRecordWithType:(MDSearchType)type completion:(void(^)(BOOL state))completion;

@end
