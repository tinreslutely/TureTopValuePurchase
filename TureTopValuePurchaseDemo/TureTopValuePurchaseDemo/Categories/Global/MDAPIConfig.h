//
//  MDAPIConfig.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/20.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDAPIConfig : NSObject

@property(nonatomic,strong) NSString* loginApiURLString;//用户登录
@property(nonatomic,strong) NSString* memberApiURLString;//我的信息
@property(nonatomic,strong) NSString* memberInfoApiURLString;//个人信息
@property(nonatomic,strong) NSString* nickNameApiURLString;//获取用户昵称
@property(nonatomic,strong) NSString* alterMemerInfoApiURLString;//修改用户信息
@property(nonatomic,strong) NSString* alterShopInfoApiURLString;//修改店铺信息
@property(nonatomic,strong) NSString* productSearchApiURLString;//商品搜索
@property(nonatomic,strong) NSString* shopSearchApiURLString;//店铺搜索
@property(nonatomic,strong) NSString* submitOrderApiURLString;//商品订单提交
@property(nonatomic,strong) NSString* submitCardOrderApiURLString;//商机卡订单提交
@property(nonatomic,strong) NSString* submitFaceOrderApiURLString;//提交面对面订单
@property(nonatomic,strong) NSString* publicshApiURLString;//发布商品
@property(nonatomic,strong) NSString* uploadPicApiURLString;//图片上传
@property(nonatomic,strong) NSString* categoriesApiURLString;//获取产品类目（第一级和第一级类目相关的二、三级）
@property(nonatomic,strong) NSString* secondCategoriesApiURLString;//获取产品的二、三级类目
@property(nonatomic,strong) NSString* facesPayCategoriesApiURLString;//获取面对面支付首页分类数据
@property(nonatomic,strong) NSString* facesPayCitiesApiURLString;//获取面对面支付首页城市区域数据
@property(nonatomic,strong) NSString* facesPayStreetShopApiURLString;//获取面对面支付首页街道数据
@property(nonatomic,strong) NSString* facesPayShopApiURLString;//获取面对面支付首页街道数据
@property(nonatomic,strong) NSString* shopConciseInformationApiURLString;//获取店铺首页数据
@property(nonatomic,strong) NSString* shopDetailApiURLString;//获取店铺详细数据
@property(nonatomic,strong) NSString* loginOutApiURLString;//退出登录
@property(nonatomic,strong) NSString* homeApiURLString;//首页数据
@property(nonatomic,strong) NSString* homeLikeProductApiURLString;//首页您可能喜欢的商品数据
@property(nonatomic,strong) NSString* cartApiURLString ;//购物车信息
@property(nonatomic,strong) NSString* cartAlertProductApiURLString;//编辑购物车商品数量
@property(nonatomic,strong) NSString* cartRemoveProductApiURLString;//删除购物车商品
@property(nonatomic,strong) NSString* totalMessageApiURLString;//消息总条数
@property(nonatomic,strong) NSString* noReadNumberMessageApiURLString;//未读消息明细总数
@property(nonatomic,strong) NSString* normalMessageApiURLString;//消息列表
@property(nonatomic,strong) NSString* normalNotifyApiURLString;//通知列表
@property(nonatomic,strong) NSString* normalMessageDetailApiURLString;//消息详情
@property(nonatomic,strong) NSString* normalNotifyDetailApiURLString;//通知详情
@property(nonatomic,strong) NSString* removeMessageDetailApiURLString;//删除消息
@property(nonatomic,strong) NSString* removeNotifyDetailApiURLString;//删除通知
@property(nonatomic,strong) NSString* markReadMessageApiURLString;//消息标记已读
@property(nonatomic,strong) NSString* markReadNotifyApiURLString;//通知标记已读
@property(nonatomic,strong) NSString* paymentOrderInformationApiURLString;//支付订单信息
@property(nonatomic,strong) NSString* submitpaymentOrderApiURLString;//订单支付
@property(nonatomic,strong) NSString* cancelPaymentOrderApiURLString;//取消订单
@property(nonatomic,strong) NSString* walletBalanceApiURLString;//获取电子钱包余额
@property(nonatomic,strong) NSString* cardBalanceApiURLString;//获取卡包余额
@property(nonatomic,strong) NSString* walletRechargeApiURLString;//电子钱包充值
@property(nonatomic,strong) NSString* cardRechargeApiURLString;//卡包充值
@property(nonatomic,strong) NSString* facesBannefrApiURLString;//获取面对面banner图


+(instancetype)sharedConfig;

@end
