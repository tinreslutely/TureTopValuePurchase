//
//  MD5Hepler.h
//  MicroValuePurchase
//  MD5加密帮助类
//  Created by 李晓毅 on 15/10/23.
//  Copyright (c) 2015年 TureTop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Hepler : NSObject

+ (NSString *)md5HexDigest:(NSString*)input;

@end
