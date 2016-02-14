//
//  MDCommon.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDCommon : NSObject

+(NSString*)imageURLStringForNetworkStatus:(NSString*)imageURL width:(int)width height:(int)height;
+(void)reshipWebURLWithNavigationController:(UINavigationController*)navigationController pageType:(MDWebPageURLType)pageType title:(NSString*)title parameters:(NSDictionary*)parameters isNeedLogin:(BOOL)isNeedLogin loginTipBlock:(void(^)())loginTipBlock;
+(NSDictionary*)urlParameterConvertDictionaryWithURL:(NSString*)url;
+(NSString*)sexTextWithValue:(int)value;
@end
