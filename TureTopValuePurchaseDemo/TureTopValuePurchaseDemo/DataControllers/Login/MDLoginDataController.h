//
//  MDLoginDataController.h
//  TureTopValuePurchaseDemo
//  用户登录控制器
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDLoginDataController : NSObject

-(void)submitDataWithUserName:(NSString*)username password:(NSString*)password rememberPW:(BOOL)rememberPW completion:(void(^)(BOOL state, NSString *msg))completion;

@end
