//
//  MDAppData.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/21.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDAppData : NSObject

@property(assign,nonatomic) BOOL isLogin;//是否登录

/*基本信息*/
@property(strong,nonatomic) NSString *userCode;//用户账户
@property(strong,nonatomic) NSString *userName;//用户名
@property(strong,nonatomic) NSString *userId;//用户ID
@property(strong,nonatomic) NSString *phone;//手机号码
@property(strong,nonatomic) NSString *token;//加密的令牌

/*会员信息*/
@property(strong,nonatomic) NSString *headPortrait;//头像地址
@property(strong,nonatomic) NSString *nickName;//昵称
@property(strong,nonatomic) NSString *sex;//性别
@property(strong,nonatomic) NSString *area;//区域
@property(strong,nonatomic) NSString *userGrade;//会员等级

/*地理位置*/
@property(strong,nonatomic) NSString *locationCity;//所在城市
@property(strong,nonatomic) NSString *locationLongitude;//所在位置的longitude
@property(strong,nonatomic) NSString *locationLatitude;//所在位置的latitude

/*网络状态*/
@property(assign,nonatomic) int networkStatus;//当前网络状态：无网络（-1） 2G/3G低速网络（0） 4G网络（1） WiFi网络（2）


@property(strong,nonatomic) NSString *appFunctionType;//0-超值购  1-快乐购

/*购物车*/
@property(assign,nonatomic) int cartTotal;//购物车商品总数量

@property(strong,nonatomic) NSString *mergeCode;//当前支付的订单号

+(instancetype)sharedData;

@end
