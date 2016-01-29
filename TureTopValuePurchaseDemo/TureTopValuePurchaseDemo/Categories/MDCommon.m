//
//  MDCommon.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDCommon.h"

@implementation MDCommon

#pragma mark public methods
/*!
 *  根据网络的不同来获取不同尺寸的网络图片
 *  2G/3G网络下根据size参数来缩小图片
 *
 *
 *  @param imageURL   网络图片路径
 *  @param width 图片宽度
 *  @param width 图片高度
 *
 *  @return 图片路径
 */
+(NSString*)imageURLStringForNetworkStatus:(NSString*)imageURL width:(int)width height:(int)height{
    return APPDATA.networkStatus < 1 ? [NSString stringWithFormat:@"%@_%d×%d", imageURL, width, height] : imageURL;
}

/**
 *  根据页面类型得到跳转的页面URL，创建一个含有webview的控制器，将该控制器在当前navigationController中进栈
 *
 *  @param navigationController 导航控制器
 *  @param pageType             页面类型
 *  @param title                标题
 *  @param parameters           参数字典
 *  @param isNeedLogin          是否需要登录
 */
+(void)reshipWebURLWithNavigationController:(UINavigationController*)navigationController pageType:(MDWebPageURLType)pageType title:(NSString*)title parameters:(NSDictionary*)parameters isNeedLogin:(BOOL)isNeedLogin loginTipBlock:(void(^)())loginTipBlock{
    if(isNeedLogin && !APPDATA.isLogin){
        [navigationController pushViewController:[[NSClassFromString(@"MDLoginViewController") alloc] init] animated:YES];
        if(loginTipBlock != nil){
            loginTipBlock();
        }
        return;
    }
    MDWebViewController *baseWebViewController = [[MDWebViewController alloc] init];
    baseWebViewController.navigateTitle = title;
    baseWebViewController.requestURL = [self completeWebURLWithPageType:pageType parameters:parameters] ;
    [navigationController pushViewController:baseWebViewController animated:YES];
}

#pragma mark private methods

/**
 *  根据跳转页面的类型获取web页面的url和参数得到目标url
 *
 *  @param type       页面类型
 *  @param parameters 页面参数
 *
 *  @return url
 */
+(NSString*)completeWebURLWithPageType:(MDWebPageURLType)type parameters:(NSDictionary*)parameters{
    NSString *url = @"";
    switch (type) {
        case MDWebPageURLTypeRegister://注册
            url = PAGECONFIG.registerPageURLString;
            break;
        case MDWebPageURLTypeContacts://我的-我的人脉
            url = PAGECONFIG.contactsPageURLString;
            break;
        case MDWebPageURLTypeProdManage://我的-商品管理
            url = PAGECONFIG.prodManagePageURLString;
            break;
        case MDWebPageURLTypeShopList://我的-商家中心-进入店铺
            url = PAGECONFIG.shopListPageURLString;
            break;
        case MDWebPageURLTypeBusinessCenter://我的-商家中心
            url = PAGECONFIG.businessCenterPageURLString;
            break;
        case MDWebPageURLTypeBusinessCardNavg://我的-我的商机卡
            url = PAGECONFIG.businessCardNavgPageURLString;
            break;
        case MDWebPageURLTypeFaceOrder://我的-面对面订单
            url = PAGECONFIG.faceOrderPageURLString;
            break;
        case MDWebPageURLTypePoint://我的-我的积分
            url = PAGECONFIG.pointPageURLString;
            break;
        case MDWebPageURLTypeCardBalance://我的-我的卡包
            url = PAGECONFIG.cardBalancePageURLString;
            break;
        case MDWebPageURLTypeForgetPassword://忘记密码
            url = PAGECONFIG.forgetPasswordPageURLString;
            break;
        case MDWebPageURLTypeHome://首页
            url = PAGECONFIG.homePageURLString;
            break;
        case MDWebPageURLTypeCategory://类目
            url = PAGECONFIG.categoryPageURLString;
            break;
        case MDWebPageURLTypeCart://购物车
            url = PAGECONFIG.cartPageURLString;
            break;
        case MDWebPageURLTypeShop://店铺
            url = PAGECONFIG.shopPageURLString;
            break;
        case MDWebPageURLTypeProductDetail://商品详情
            url = PAGECONFIG.productDetailPageURLString;
            break;
        case MDWebPageURLTypeConfirmOrder://订单确认
            url = PAGECONFIG.confirmOrderPageURLString;
            break;
        case MDWebPageURLTypeFace://面对面
            url = PAGECONFIG.facePageURLString;
            break;
        case MDWebPageURLTypeBusinessPresence://商家进驻
            url = PAGECONFIG.businessPresencePageURLString;
            break;
        case MDWebPageURLTypeMakeMoney://我要赚钱
            url = PAGECONFIG.makeMoneyPageURLString;
            break;
        case MDWebPageURLTypeMarketingPromotion://我要推广
            url = PAGECONFIG.marketingPromotionPageURLString;
            break;
        case MDWebPageURLTypeDownloadApp://下载App
            url = PAGECONFIG.downloadAppPageURLString;
            break;
        case MDWebPageURLTypeHunredPercent://100%返利
            url = PAGECONFIG.hunredPercentPageURLString;
            break;
        case MDWebPageURLTypeCardPurchase://我要购卡-购物商机卡
            url = PAGECONFIG.cardPurchasePageURLString;
            break;
        case MDWebPageURLTypeCardConfirm://我要购卡-确认订单
            url = PAGECONFIG.cardConfirmPageURLString;
            break;
        case MDWebPageURLTypeReceiveAddress://我的-收货地址
            url = PAGECONFIG.receiveAddressPageURLString;
            break;
        case MDWebPageURLTypeCollection://我的-收藏的商品/收藏的店铺  参数：tab 值为0-收藏商品  值为1-收藏店铺
            url = PAGECONFIG.collectionPageURLString;
            break;
        case MDWebPageURLTypeOrderList://我的-我的订单
            url = PAGECONFIG.orderListPageURLString;
            break;
        case MDWebPageURLTypeWallet://我的-我的钱包
            url = PAGECONFIG.walletPageURLString;
            break;
        case MDWebPageURLTypeMessage://我的消息
            url = PAGECONFIG.messagePageURLString;
            break;
        case MDWebPageURLTypeHappyPurchase://快乐购
            url = PAGECONFIG.happlyPurchasePageURLString;
            break;
        case MDWebPageURLTypeOpenCertificate://开通资格
            url = PAGECONFIG.openCertificatePageURLString;
            break;
        case MDWebPageURLTypeMdcollege://铭道学院
            url = PAGECONFIG.mdcollegePageURLString;
            break;
        case MDWebPageURLTypeAccountSecurity://账户安全
            url = PAGECONFIG.accountSecurityPageURLString;
            break;
        case MDWebPageURLTypeAlertLoginPW://修改登陆密码
            url = PAGECONFIG.alertLoginPWPageURLString;
            break;
        case MDWebPageURLTypeAlertPayPW://修改支付密码
            url = PAGECONFIG.alertPayPWPageURLString;
            break;
        case MDWebPageURLTypeFaceDetail://店铺详情
            url = PAGECONFIG.faceDetailPageURLString;
            break;
        case MDWebPageURLTypeProducts://产品列表
            url = PAGECONFIG.productsPageURLString;
            break;
        case MDWebPageURLTypeFaces://面对面支付
            url = PAGECONFIG.facesPageURLString;
            break;
        case MDWebPageURLTypePublishProduct://发布商品
            url = PAGECONFIG.publishProductPageURLString;
            break;
        case MDWebPageURLTypeSubmitOrder://填写订单
            url = PAGECONFIG.submitOrderPageURLString;
            break;
        case MDWebPageURLTypePaySuccess://填写订单
            url = PAGECONFIG.paySuccessPageURLString;
            break;
        case MDWebPageURLTypeFaceShopPermit:
            url = PAGECONFIG.faceShopPermitPageURLString;
            break;
        case MDWebPageURLTypeCardRecharge:
            url = PAGECONFIG.cardRechargePageURLString;
            break;
        case MDWebPageURLTypeWalletRecharge:
            url = PAGECONFIG.walletRechargePageURLString;
            break;
        case MDWebPageURLTypeAbout:
            url = PAGECONFIG.aboutPageURLString;
            break;
    }
    url = [NSString stringWithFormat:@"%@%@",wapURL,url];
    NSString *paramString = @"";
    if(parameters != nil && parameters.count > 0){
        for (NSString *key in parameters) {
            paramString = [paramString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,parameters[key]]];
        }
    }
    if(APPDATA.isLogin){
        paramString = [NSString stringWithFormat:@"%@=%@&%@",@"token",APPDATA.token,paramString];
    }
    paramString = [NSString stringWithFormat:@"%@=%@&%@",@"phoneType",@"ios",paramString];
    paramString = [NSString stringWithFormat:@"%@=%f&%@",@"phoneSysVersion",__IPHONE_SYSTEM_VERSION,paramString];
    return [NSString stringWithFormat:@"%@?%@", url, paramString];
}

@end
