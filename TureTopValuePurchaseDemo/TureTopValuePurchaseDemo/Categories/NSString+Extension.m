//
//  NSString+Extension.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/29.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString(Extension)

/*! @brief
 *  判断该字符串中是否存在指定的字符串（兼容iOS7）
 *
 *  @param str 指定的字符串
 *
 *  @return <#return value description#>
 */
-(BOOL)extensionWithContainsString:(NSString *)str NS_AVAILABLE(10_10, 7_0){
    return __IPHONE_SYSTEM_VERSION < 8 ? ([self rangeOfString:str].location != NSNotFound) : [self containsString:str];
}

@end
