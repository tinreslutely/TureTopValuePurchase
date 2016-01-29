//
//  MDLoginDataController.m
//  TureTopValuePurchaseDemo
//  用户登录控制器
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDLoginDataController.h"
#import "AESCrypt.h"

@implementation MDLoginDataController

-(void)submitDataWithUserName:(NSString*)username password:(NSString*)password rememberPW:(BOOL)rememberPW completion:(void(^)(BOOL state, NSString *msg))completion{
    [MDHttpManager POST:APICONFIG.loginApiURLString parameters:@{@"username":username,@"password":password} sucessBlock:^(id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *stateCode = [dic objectForKey:@"state"];
        BOOL state = [self stateForResponseWithCode:stateCode];
        if(!state){
            completion(NO,[dic objectForKey:@"result"]);
            return ;
        }
        NSDictionary *modelDic = [dic objectForKey:@"result"];
        [self saveLoginInforationForLocalWithUserId:[modelDic objectForKey:@"userId"] userName:[modelDic objectForKey: @"userName"] phone:[modelDic objectForKey:@"phone"] token:[modelDic objectForKey: @"token"] rememberPW:rememberPW userCode:username password:password];
        completion(YES, @"登录成功");
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error]);
    }];
}

/**
 *  保存用户登录信息到plist
 *
 *  @param userId     用户ID
 *  @param userName   用户名
 *  @param phone      用户手机号码
 *  @param token      token
 *  @param rememberPW 记住密码
 *  @param password   密码  保存的时候将会做AES加密
 */
-(void)saveLoginInforationForLocalWithUserId:(NSString*)userId userName:(NSString*)userName phone:(NSString*)phone token:(NSString*)token rememberPW:(BOOL)rememberPW userCode:(NSString*)userCode password:(NSString*)password{
    [MDUserDefaultHelper saveForKey:userIDKey value:userId];
    [MDUserDefaultHelper saveForKey:userNameKey value:userName];
    [MDUserDefaultHelper saveForKey:userPhoneKey value:phone];
    [MDUserDefaultHelper saveForKey:tokenKey value:token];
    [MDUserDefaultHelper saveForKey:userCodeKey value:userCode];
    if(rememberPW){
        [MDUserDefaultHelper saveForKey:rememberPWKey value:[NSString stringWithFormat:@"%d",rememberPW]];
        [MDUserDefaultHelper saveForKey:userPassWordKey value:[AESCrypt encrypt:password password:AESCryptKey]];
    }else{
        [MDUserDefaultHelper removeForKey:rememberPWKey];
        [MDUserDefaultHelper removeForKey:userPassWordKey];
    }
    
    APPDATA.isLogin = YES;
    APPDATA.token = token;
    APPDATA.userId = userId;
    APPDATA.userName = userName;
    APPDATA.userCode = userCode;
    APPDATA.phone = phone;
}

/**
 *  处理服务端返回的状态编码，写相关的日志
 *
 *  @param code 状态编码
 *
 *  @return 是否成功
 */
-(BOOL)stateForResponseWithCode:(NSString*)code{
    BOOL state = NO;
    NSString *message;
    switch ([code intValue]) {
        case 200:
            message = @"业务操作成功";
            state = YES;
            break;
        case 100:
            message = @"服务端未知错误";
            break;
        case 101:
            message = @"业务操作不成功，例如请求参数不合法、包括长度，是否可空，值的范围等";
            break;
        case 102:
            message = @"请求解密不正确：被恶意篡改等";
            break;
        case 103:
            message = @"无权访问，权限不足错误";
            break;
        case 104:
            message = @"未登录";
            break;
        case 105:
            message = @"会话过期，重新登录";
            break;
        default:
            message = @"其他";
            break;
    }
    NSLog(@"返回的状态码:%@,信息:%@",code,message);
    return state;
}

@end
