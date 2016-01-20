//
//  MDPageConfig.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/20.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDPageConfig.h"

@implementation MDPageConfig

+(instancetype)sharedConfig{
    static dispatch_once_t onceToken;
    static MDPageConfig *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MDPageConfig alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if(self = [super init]){
        self.registerPageURLString = @"/page/login-register/register.jsp";//注册
        self.forgetPasswordPageURLString = @"/page/login-register/retrieve_password.jsp";//找回密码
        self.homePageURLString = @"/html/channel/index/index.html";//首页
        self.categoryPageURLString = @"/channel/czg/category.do";//类目
        self.cartPageURLString = @"/page/shopping_cart.jsp";//购物车
        self.shopPageURLString = @"/shop/index.do";//店铺
        self.productDetailPageURLString = @"/product/detail.do";//商品详情
        self.facePageURLString = @"/face/index.do";//面对面
        self.confirmOrderPageURLString = @"/order/confirm.do";//订单确认
        self.businessPresencePageURLString = @"/page/business-presence/index.jsp";//商家进驻
        self.makeMoneyPageURLString = @"/page/make-money/index.jsp";//我要赚钱
        self.marketingPromotionPageURLString = @"/page/marketing-promotion/index.jsp";//我要推广
        self.downloadAppPageURLString = @"/page/app_download.jsp";//下载App
        self.hunredPercentPageURLString = @"/hundred_percent.html";//100%返利
        self.cardPurchasePageURLString = @"/page/card/card_purchase.jsp";//我要购卡-购物商机卡
        self.cardConfirmPageURLString = @"/page/card/card_confirm.jsp";//我要购卡-确认订单
        self.receiveAddressPageURLString = @"/page/member/receive_address.jsp";//我的-收货地址
        self.collectionPageURLString = @"/page/member/my_collection.jsp";//我的-收藏的商品/收藏的店铺
        self.orderListPageURLString = @"/page/order/order_list.jsp";//我的-我的订单
        self.walletPageURLString = @"/page/finance/my_wallet.jsp";//我的-我的钱包
        self.cardBalancePageURLString = @"/account/detail/getCardBalance.do";//我的卡包
        self.pointPageURLString = @"/page/integral/myPoint.jsp";//我的-我的积分
        self.faceOrderPageURLString = @"/page/order/face_order_list.jsp";//我的-面对面支付
        self.businessCardNavgPageURLString = @"/page/member/businessCard/navg.jsp";//我的-我的商机卡
        self.businessCenterPageURLString = @"/shop/index.do";//我的-商家中心
        self.shopListPageURLString = @"/shop/list.do";//我的-商家中心-进入店铺
        self.prodManagePageURLString = @"/page/prod/prod_manage.jsp";//我的-商品管理
        self.contactsPageURLString = @"/contact/getContacts.do";//我的-我的人脉
        
        self.messagePageURLString = @"/page/member/my_message.jsp";//我的消息
        self.payPageURLString = @"/page/pay/wap/pay.jsp";//订单支付
        self.loginPageURLString = @"/page/login.jsp";//登录
        self.happlyPurchasePageURLString = @"/channel/tttm/index.do";//快乐购
        self.happlyPurchase2PageURLString = @"/html/channel/index/index_tttm.html";//快乐购
        self.openCertificatePageURLString = @"/userVoucher/input.do";//开通资格
        self.mdcollegePageURLString = @"/page/introduction_page/hundred_percent.html";//铭道学院
        self.accountSecurityPageURLString = @"/page/member/setting/account_security.jsp";//账户安全
        self.alertLoginPWPageURLString = @"/member/password/getPhoneForChangeLoginPaw.do";//修改登陆密码
        self.alertPayPWPageURLString = @"/member/password/getPhoneForPayPassword.do";//修改支付密码
        self.faceDetailPageURLString = @"/face/shop.do";//店铺详情
        
        self.productsPageURLString = @"/page/channel/list.jsp";
        self.shopOrderPageURLString = @"/page/order/shop_order_list.jsp";//店铺订单
        self.facesPageURLString = @"/page/shop/face2face.jsp";//面对面支付
        self.publishProductPageURLString = @"/product/toPublish.do";//发布商品
        self.submitOrderPageURLString = @"/order/confirmForApp.do";//填写订单
        
        
        self.paySuccessPageURLString = @"/page/pay/wap/pay_success2.jsp";//填写订单
        self.faceShopOrderPageURLString = @"/page/order/face_shop_order_list.jsp";//店铺订单
        self.faceShopPermitPageURLString = @"/shop/shopCertificate.do";//店铺证照
        self.cardRechargePageURLString = @"/page/pay/wap/card_recharge.jsp";//卡包充值
        self.walletRechargePageURLString = @"/page/pay/wap/recharge.jsp";//电子钱包充值
        self.aboutPageURLString = @"/page/member/setting/about_purchase.jsp";
    }
    return self;
}

@end
