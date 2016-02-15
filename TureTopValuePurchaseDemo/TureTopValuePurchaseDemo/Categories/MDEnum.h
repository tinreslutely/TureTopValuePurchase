//
//  MDEnum.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/13.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#ifndef MDEnum_h
#define MDEnum_h


/*! @brief 定位服务block类型
 *
 */
typedef void(^locationUpdatedBlock)();

/*! @brief
 *  定位失败block类型
 */
typedef void(^locationErrorBlock)();



/*!
 *  app数据类型
 */
typedef NS_ENUM(NSInteger, MDPurchaseType) {
    /*!
     *  超值购
     */
    MDPurchaseTypeValue = 0,
    /*!
     *  快乐购
     */
    MDPurchaseTypeHapple
};

/*!
 *  搜索类型
 */
typedef NS_ENUM(NSInteger,MDSearchType) {
    /*!
     *  商品
     */
    MDSearchTypeProduct = 0,
    /*!
     *  店铺
     */
    MDSearchTypeShop,
    /*!
     *  面对面店铺
     */
    MDSearchTypeFacesShop
};

/*!
 *  支付类型
 */
typedef NS_ENUM(NSInteger,MDPaymentType) {
    /*!
     *  支付
     */
    MDPaymentTypeWebChat = 0,
    /*!
     *  支付宝
     */
    MDPaymentTypeAlipay,
    /*!
     *  财付通
     */
    MDPaymentTypeTenpay,
    /*!
     *  电子钱包\卡包全额
     */
    MDPaymentTypeSystempay
};

/*!
 *  充值类型
 */
typedef NS_ENUM(NSInteger,MDRechargeType) {
    /*!
     *  卡包充值
     */
    MDRechargeTypeCard = 1,
    /*!
     *  电子钱包充值
     */
    MDRechargeTypeWallet
};

/*!
 *  账户类型
 */
typedef NS_ENUM(NSInteger,MDBalanceType) {
    /*!
     *  卡包
     */
    MDBalanceTypeCard = 1,
    /*!
     *  电子钱包
     */
    MDBalanceTypeWallet
};

/*!
 *  订单类型
 */
typedef NS_ENUM(NSInteger, MDOrderType) {
    /*!
     *  商品订单
     */
    MDOrderTypeNormal = 0,
    /*!
     *  商机卡订单
     */
    MDOrderTypeBusinessCard,
    /*!
     *  面对面订单
     */
    MDOrderTypeFaces,
    /*!
     *  普通收费单(资格证等)
     */
    MDOrderTypeCharge
};

/*!
 *  读取资源文件信息
 */
typedef NS_ENUM(NSInteger,LDReadResourceStateType) {
    /*!
     *  读取成功
     */
    LDReadResourceStateTypeSuccess = 0,
    /*!
     *  文件不存在
     */
    LDReadResourceStateTypePathNoExist = 1,
    /*!
     *  内容转换json错误
     */
    LDReadResourceStateTypeContentTransformError = 2
};

/*! @brief
 *  web页面类型
 */
typedef NS_ENUM(NSInteger,MDWebPageURLType) {
    /*!
     *  注册
     */
    MDWebPageURLTypeRegister,
    /*!
     *  找回密码
     */
    MDWebPageURLTypeForgetPassword,
    /*!
     *  首页
     */
    MDWebPageURLTypeHome,
    /*!
     *  类目
     */
    MDWebPageURLTypeCategory,
    /*!
     *  购物车
     */
    MDWebPageURLTypeCart,
    /*!
     *  店铺
     */
    MDWebPageURLTypeShop,
    /*!
     *  商品详情
     */
    MDWebPageURLTypeProductDetail,
    /*!
     *  面对面首页
     */
    MDWebPageURLTypeConfirmOrder,
    /*!
     *  订单确认
     */
    MDWebPageURLTypeFace,
    /*!
     *  商家进驻
     */
    MDWebPageURLTypeBusinessPresence,
    /*!
     *  我要赚钱
     */
    MDWebPageURLTypeMakeMoney,
    /*!
     *  我要推广
     */
    MDWebPageURLTypeMarketingPromotion,
    /*!
     *  下载APP
     */
    MDWebPageURLTypeDownloadApp,
    /*!
     *  100%返利
     */
    MDWebPageURLTypeHunredPercent,
    /*!
     *  我要购卡-购物商机卡
     */
    MDWebPageURLTypeCardPurchase,
    /*!
     *  我要购卡-确认订单
     */
    MDWebPageURLTypeCardConfirm,
    /*!
     *  我的-收货地址
     */
    MDWebPageURLTypeReceiveAddress,
    /*!
     *  我的收藏商品/收藏店铺
     */
    MDWebPageURLTypeCollection,
    /*!
     *  我的-我的订单
     */
    MDWebPageURLTypeOrderList,
    /*!
     *  我的-我的钱包
     */
    MDWebPageURLTypeWallet,
    /*!
     *  我的卡包
     */
    MDWebPageURLTypeCardBalance,
    /*!
     *  我的积分
     */
    MDWebPageURLTypePoint,
    /*!
     *  面对面支付
     */
    MDWebPageURLTypeFaceOrder,
    /*!
     *  我的商机卡
     */
    MDWebPageURLTypeBusinessCardNavg,
    /*!
     *  我的-商家中心
     */
    MDWebPageURLTypeBusinessCenter,
    /*!
     *  进入店铺
     */
    MDWebPageURLTypeShopList,
    /*!
     *  商品管理
     */
    MDWebPageURLTypeProdManage,
    /*!
     *  我的人脉
     */
    MDWebPageURLTypeContacts,
    /*!
     *  我的消息
     */
    MDWebPageURLTypeMessage,
    /*!
     *  快乐购
     */
    MDWebPageURLTypeHappyPurchase,
    /*!
     *  开通资格
     */
    MDWebPageURLTypeOpenCertificate,
    /*!
     *  铭道学院
     */
    MDWebPageURLTypeMdcollege,
    /*!
     *  账户安全
     */
    MDWebPageURLTypeAccountSecurity,
    /*!
     *  修改登陆密码
     */
    MDWebPageURLTypeAlertLoginPW,
    /*!
     *  修改支付密码
     */
    MDWebPageURLTypeAlertPayPW,
    /*!
     *  店铺详情
     */
    MDWebPageURLTypeFaceDetail,
    /*!
     *  商品列表
     */
    MDWebPageURLTypeProducts,
    /*!
     *  面对面支付
     */
    MDWebPageURLTypeFaces,
    /*!
     *  发布商品
     */
    MDWebPageURLTypePublishProduct,
    /*!
     *  填写订单
     */
    MDWebPageURLTypeSubmitOrder,
    /*!
     *  支付成功
     */
    MDWebPageURLTypePaySuccess,
    /*!
     *  店铺证照
     */
    MDWebPageURLTypeFaceShopPermit,
    /*!
     *  卡包充值
     */
    MDWebPageURLTypeCardRecharge,
    /*!
     *  电子钱包充值
     */
    MDWebPageURLTypeWalletRecharge,
    /*!
     *  关于页面
     */
    MDWebPageURLTypeAbout
};

#endif /* MDEnum_h */
