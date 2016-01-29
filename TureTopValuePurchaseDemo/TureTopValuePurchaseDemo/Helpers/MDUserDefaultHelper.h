//
//  MDUserDefaultHelper.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/10/23.
//  Copyright (c) 2015年 TureTop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDUserDefaultHelper : NSObject
+(id)readForKey:(NSString*)key;
+(void)saveForKey:(NSString*)key value:(id)value;
+(void)removeForKey:(NSString*)key;
@end
