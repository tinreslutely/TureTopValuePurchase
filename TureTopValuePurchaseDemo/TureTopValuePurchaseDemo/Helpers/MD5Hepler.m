//
//  MD5Hepler.m
//  MicroValuePurchase
//  MD5加密帮助类
//  Created by 李晓毅 on 15/10/23.
//  Copyright (c) 2015年 TureTop. All rights reserved.
//

#import "MD5Hepler.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Hepler

/**
 *  MD5加密
 *
 *  @param input 明文
 *
 *  @return 密文
 */
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end
