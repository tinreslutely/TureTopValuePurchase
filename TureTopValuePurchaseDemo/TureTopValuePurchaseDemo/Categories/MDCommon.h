//
//  MDCommon.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDCommonDelegate : NSObject<UIAlertViewDelegate>

@end

@interface MDCommon : NSObject
+(id _Nullable)readDataForJsonFileWithPath:(NSString* _Nullable)path;

+(NSString* _Nullable)imageURLStringForNetworkStatus:(NSString* _Nullable)imageURL width:(int)width height:(int)height;

+(void)reshipWebURLWithNavigationController:(UINavigationController* _Nullable)navigationController pageType:(MDWebPageURLType)pageType title:(NSString* _Nullable)title parameters:(NSDictionary* _Nullable)parameters isNeedLogin:(BOOL)isNeedLogin loginTipBlock:(void(^ _Nullable)())loginTipBlock;

+(void)reshipWebURLWithNavigationController:(UINavigationController* _Nullable)navigationController pageURL:(NSString* _Nullable)pageURL;

+(NSDictionary* _Nullable)urlParameterConvertDictionaryWithURL:(NSString* _Nullable)url;

+(NSString* _Nullable)sexTextWithValue:(int)value;

+(NSString* _Nullable)appendParameterForAppWithURL:(NSString* _Nullable)urlString;

+(void)checkedVersionForAppWithUpdateWithController:(UIViewController* _Nullable)controller isShowNewVersionMessage:(BOOL)isShowNewVersionMessage;

+(UIViewController* _Nullable)controllerForPagePathWithURL:(NSString* _Nullable)url currentController:(UIViewController* _Nullable)currentController token:(NSString* _Nullable)token;
@end
