//
//  MDUserDefaultHelper.m
//  MicroValuePurchase
//  本地存档帮助类
//  Created by 李晓毅 on 15/10/23.
//  Copyright (c) 2015年 TureTop. All rights reserved.
//

#import "MDUserDefaultHelper.h"

@implementation MDUserDefaultHelper

+(id)readForKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)saveForKey:(NSString*)key value:(id)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
