//
//  MDAPIConfig.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/20.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDAPIConfig.h"

@implementation MDAPIConfig

@synthesize loginApiURLString,memberApiURLString,nickNameApiURLString,alterMemerInfoApiURLString,alterShopInfoApiURLString,productSearchApiURLString,shopSearchApiURLString,submitOrderApiURLString,submitCardOrderApiURLString,submitFaceOrderApiURLString,publicshApiURLString,uploadPicApiURLString,categoriesApiURLString,secondCategoriesApiURLString,facesPayCategoriesApiURLString,facesPayCitiesApiURLString,facesPayShopApiURLString,facesPayStreetShopApiURLString,shopConciseInformationApiURLString,shopDetailApiURLString,loginOutApiURLString,homeApiURLString,homeLikeProductApiURLString,cartAlertProductApiURLString,cardBalanceApiURLString,cancelPaymentOrderApiURLString,cardRechargeApiURLString,cartApiURLString,cartRemoveProductApiURLString,totalMessageApiURLString,noReadNumberMessageApiURLString,normalMessageApiURLString,normalMessageDetailApiURLString,normalNotifyApiURLString,normalNotifyDetailApiURLString,walletBalanceApiURLString,walletRechargeApiURLString,markReadMessageApiURLString,markReadNotifyApiURLString,memberInfoApiURLString,paymentOrderInformationApiURLString,removeMessageDetailApiURLString,removeNotifyDetailApiURLString,submitpaymentOrderApiURLString,facesBannefrApiURLString;

+(instancetype)sharedConfig{
    static dispatch_once_t onceToken;
    static MDAPIConfig *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MDAPIConfig alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if(self = [super init]){
        self.loginApiURLString = [apiURL stringByAppendingString:@"/login.do"];//用户登录
        self.memberApiURLString = [apiURL stringByAppendingString:@"/appinter/member/myList.do"];//我的信息
        self.memberInfoApiURLString = [apiURL stringByAppendingString:@"/appinter/member/myInfo.do"];//个人信息
        self.nickNameApiURLString = [apiURL stringByAppendingString:@"/appinter/member/nickName.do"];//获取用户昵称
        self.alterMemerInfoApiURLString = [apiURL stringByAppendingString:@"/appinter/member/update.do"];//修改用户信息
        self.alterShopInfoApiURLString = [apiURL stringByAppendingString:@"/appinter/shop/save.do"];//修改店铺信息
        self.productSearchApiURLString = [apiURL stringByAppendingString:@"/appinter/search/productSearch.do"];//商品搜索
        self.shopSearchApiURLString = [apiURL stringByAppendingString:@"/appinter/search/shopSearch.do"];//店铺搜索
        self.submitOrderApiURLString = [apiURL stringByAppendingString:@"/appinter/order/submit.do"];//商品订单提交
        self.submitCardOrderApiURLString = [apiURL stringByAppendingString:@"/appinter/cardOrder/submit.do"];//商机卡订单提交
        self.submitFaceOrderApiURLString = [apiURL stringByAppendingString:@"/appinter/faceOrder/submit.do"];//提交面对面订单
        self.publicshApiURLString = [apiURL stringByAppendingString:@"/appinter/product/publish.do"];//发布商品
        self.uploadPicApiURLString = [apiURL stringByAppendingString:@"/pic/upload.do"];//图片上传
        self.categoriesApiURLString = [apiURL stringByAppendingString:@"/appinter/category.do"];//获取产品类目（第一级和第一级类目相关的二、三级）
        self.secondCategoriesApiURLString = [apiURL stringByAppendingString:@"/appinter/getSecondTypes.do"];//获取产品的二、三级类目
        self.facesPayCategoriesApiURLString = [apiURL stringByAppendingString:@"/appinter/face/showIndustry.do"];//获取面对面支付首页分类数据
        self.facesPayCitiesApiURLString = [apiURL stringByAppendingString:@"/appinter/face/showCityArea.do"];//获取面对面支付首页城市区域数据
        self.facesPayStreetShopApiURLString = [apiURL stringByAppendingString:@"/appinter/face/streetShopCount.do"];//获取面对面支付首页街道数据
        self.facesPayShopApiURLString = [apiURL stringByAppendingString:@"/appinter/face/faceShoplist.do"];//获取面对面支付首页街道数据
        self.shopConciseInformationApiURLString = [apiURL stringByAppendingString:@"/appinter/shop/index.do"];//获取店铺首页数据
        self.shopDetailApiURLString = [apiURL stringByAppendingString:@"/appinter/shop/getShopDetail.do"];//获取店铺详细数据
        self.loginOutApiURLString = [apiURL stringByAppendingString:@"/loginOut.do"];//退出登录
        self.homeApiURLString = [apiURL stringByAppendingString:@"/appinter/index.do"];//首页数据
        self.homeLikeProductApiURLString = [apiURL stringByAppendingString:@"/appinter/getProducts.do"];//首页您可能喜欢的商品数据
        self.cartApiURLString = [apiURL stringByAppendingString:@"/appinter/shoppingCart/list.do"];//购物车信息
        self.cartAlertProductApiURLString = [apiURL stringByAppendingString:@"/appinter/shoppingCart/update.do"];//编辑购物车商品数量
        self.cartRemoveProductApiURLString = [apiURL stringByAppendingString:@"/appinter/shoppingCart/delete.do"];//删除购物车商品
        self.totalMessageApiURLString = [apiURL stringByAppendingString:@"/appinter/message/getMsgNums.do"];//消息总条数
        self.noReadNumberMessageApiURLString = [apiURL stringByAppendingString:@"/appinter/message/getMsgDetailNums.do"];//未读消息明细总数
        self.normalMessageApiURLString = [apiURL stringByAppendingString:@"/appinter/message/getMessages.do"];//消息列表
        self.normalNotifyApiURLString = [apiURL stringByAppendingString:@"/appinter/message/getNotices.do"];//通知列表
        self.normalMessageDetailApiURLString = [apiURL stringByAppendingString:@"/appinter/message/getMsgDetail.do"];//消息详情
        self.normalNotifyDetailApiURLString = [apiURL stringByAppendingString:@"/appinter/message/getNoticeDetail.do"];//通知详情
        self.removeMessageDetailApiURLString = [apiURL stringByAppendingString:@"/appinter/message/deleteMsg.do"];//删除消息
        self.removeNotifyDetailApiURLString = [apiURL stringByAppendingString:@"/appinter/message/deleteNotices.do"];//删除通知
        self.markReadMessageApiURLString = [apiURL stringByAppendingString:@"/appinter/message/setMsgRead.do"];//消息标记已读
        self.markReadNotifyApiURLString = [apiURL stringByAppendingString:@"/appinter/message/setNoticeRead.do"];//通知标记已读
        self.paymentOrderInformationApiURLString = [apiURL stringByAppendingString:@"/appinter/order/getPayInfo.do"];//支付订单信息
        self.submitpaymentOrderApiURLString = [payURL stringByAppendingString:@"/apppay/pay.do"];//订单支付
        self.cancelPaymentOrderApiURLString = [apiURL stringByAppendingString:@"/apppay/calcelPay.do"];//取消订单
        self.walletBalanceApiURLString = [apiURL stringByAppendingString:@"/finance/wallet/getWalletBalance.do"];//获取电子钱包余额
        self.cardBalanceApiURLString = [apiURL stringByAppendingString:@"/finance/card/getCardBalance.do"];//获取卡包余额
        self.walletRechargeApiURLString = [apiURL stringByAppendingString:@"/app/recharge/walletRecharge.do"];//电子钱包充值
        self.cardRechargeApiURLString = [apiURL stringByAppendingString:@"/app/recharge/cardRecharge.do"];//卡包充值
        self.facesBannefrApiURLString = [apiURL stringByAppendingString:@"/appinter/face/getFTFBanners.do"];
    }
    return self;
}
@end
