//
//  MDPageConfig.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/20.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDPageConfig : NSObject

@property(nonatomic,strong) NSString *registerPageURLString;//注册
@property(nonatomic,strong) NSString *forgetPasswordPageURLString;//找回密码
@property(nonatomic,strong) NSString *homePageURLString;//首页
@property(nonatomic,strong) NSString *categoryPageURLString;//类目
@property(nonatomic,strong) NSString *cartPageURLString;//购物车
@property(nonatomic,strong) NSString *shopPageURLString;//店铺
@property(nonatomic,strong) NSString *productDetailPageURLString;//商品详情
@property(nonatomic,strong) NSString *facePageURLString;//面对面
@property(nonatomic,strong) NSString *confirmOrderPageURLString;//订单确认
@property(nonatomic,strong) NSString *businessPresencePageURLString;//商家进驻
@property(nonatomic,strong) NSString *makeMoneyPageURLString;//我要赚钱
@property(nonatomic,strong) NSString *marketingPromotionPageURLString;//我要推广
@property(nonatomic,strong) NSString *downloadAppPageURLString;//下载App
@property(nonatomic,strong) NSString *hunredPercentPageURLString;//100%返利
@property(nonatomic,strong) NSString *cardPurchasePageURLString;//我要购卡-购物商机卡
@property(nonatomic,strong) NSString *cardConfirmPageURLString;//我要购卡-确认订单
@property(nonatomic,strong) NSString *receiveAddressPageURLString;//我的-收货地址
@property(nonatomic,strong) NSString *collectionPageURLString;//我的-收藏的商品/收藏的店铺
@property(nonatomic,strong) NSString *orderListPageURLString;//我的-我的订单
@property(nonatomic,strong) NSString *walletPageURLString;//我的-我的钱包
@property(nonatomic,strong) NSString *cardBalancePageURLString;//我的卡包
@property(nonatomic,strong) NSString *pointPageURLString;//我的-我的积分
@property(nonatomic,strong) NSString *faceOrderPageURLString;//我的-面对面支付
@property(nonatomic,strong) NSString *businessCardNavgPageURLString;//我的-我的商机卡
@property(nonatomic,strong) NSString *businessCenterPageURLString;//我的-商家中心
@property(nonatomic,strong) NSString *shopListPageURLString;//我的-商家中心-进入店铺
@property(nonatomic,strong) NSString *prodManagePageURLString;//我的-商品管理
@property(nonatomic,strong) NSString *contactsPageURLString;//我的-我的人脉

@property(nonatomic,strong) NSString *messagePageURLString;//我的消息
@property(nonatomic,strong) NSString *payPageURLString;//订单支付
@property(nonatomic,strong) NSString *loginPageURLString;//登录
@property(nonatomic,strong) NSString *happlyPurchasePageURLString;//快乐购
@property(nonatomic,strong) NSString *happlyPurchase2PageURLString;//快乐购
@property(nonatomic,strong) NSString *openCertificatePageURLString;//开通资格
@property(nonatomic,strong) NSString *mdcollegePageURLString;//铭道学院
@property(nonatomic,strong) NSString *accountSecurityPageURLString;//账户安全
@property(nonatomic,strong) NSString *alertLoginPWPageURLString;//修改登陆密码
@property(nonatomic,strong) NSString *alertPayPWPageURLString;//修改支付密码
@property(nonatomic,strong) NSString *faceDetailPageURLString;//店铺详情

@property(nonatomic,strong) NSString *productsPageURLString;
@property(nonatomic,strong) NSString *shopOrderPageURLString;//店铺订单
@property(nonatomic,strong) NSString *facesPageURLString;//面对面支付
@property(nonatomic,strong) NSString *publishProductPageURLString;//发布商品
@property(nonatomic,strong) NSString *submitOrderPageURLString;//填写订单


@property(nonatomic,strong) NSString *paySuccessPageURLString;//填写订单
@property(nonatomic,strong) NSString *faceShopOrderPageURLString;//店铺订单
@property(nonatomic,strong) NSString *faceShopPermitPageURLString;//店铺证照
@property(nonatomic,strong) NSString *cardRechargePageURLString;//卡包充值
@property(nonatomic,strong) NSString *walletRechargePageURLString;//电子钱包充值
@property(nonatomic,strong) NSString *aboutPageURLString;


+(instancetype)sharedConfig;

@end
