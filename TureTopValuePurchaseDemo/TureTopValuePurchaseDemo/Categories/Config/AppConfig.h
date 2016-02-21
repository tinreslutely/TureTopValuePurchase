//
//  AppConfig.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/20.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h


/*********************     URL  START   *************************/
/*********************     URL  END     *************************/


/*********************   GLOBAL  START  *************************/
/*********************   GLOBAL  END    *************************/

/*********************   TABITEM  START *************************/
static const int tab_home_index     = 0;   //tab 主页
static const int tab_classify_index = 1;   //tab 类目
static const int tab_shop_index     = 2;   //tab 店铺
static const int tab_cart_index     = 3;   //tab 购物车
static const int tab_personal_index = 4;   //tab 个人中心
/*********************   TABITEM  END   *************************/

/********************* userdefault key start *************************/
static NSString* const tokenKey = @"token";//token
static NSString* const userIDKey = @"userID";//用户ID
static NSString* const userCodeKey = @"userCode";//登录账户
static NSString* const userPassWordKey = @"userPW";//登录密码
static NSString* const rememberPWKey = @"rememberPW";//记住密码
static NSString* const userPhoneKey = @"userPhone";//用户手机号码
static NSString* const userNameKey = @"userName";//用户名
static NSString* const userNickNameKey = @"nickName";//用户昵称
static NSString* const userHeadPortraitKey = @"headPortrait";//用户头像
static NSString* const locationCityKey = @"locality";
static NSString* const locationLongitudeKey = @"longitude";
static NSString* const locationLatitudeKey = @"latitude";
/********************* userdefault key end  *************************/


#endif /* AppConfig_h */
