//
//  MDCommon.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDCommon.h"
#import "MDPaymentViewController.h"
#import "MDRechargeViewController.h"

@implementation MDCommonDelegate

+(instancetype)sharedMDCommon{
    static dispatch_once_t onceToken;
    static MDCommonDelegate *instance;
    dispatch_once(&onceToken,^{
        instance = [[MDCommonDelegate alloc] init];
    });
    return instance;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"前往更新"]){
        [self UpdateVersion];
    }
}

-(void)UpdateVersion{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/ming-dao-chao-zhi-gou/id%@?l=zh&ls=1&mt=8",AppID]]];
}

@end

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
+(NSString* _Nullable)imageURLStringForNetworkStatus:(NSString* _Nullable)imageURL width:(int)width height:(int)height{
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
+(void)reshipWebURLWithNavigationController:(UINavigationController* _Nullable)navigationController pageType:(MDWebPageURLType)pageType title:(NSString* _Nullable)title parameters:(NSDictionary* _Nullable)parameters isNeedLogin:(BOOL)isNeedLogin loginTipBlock:(void(^ _Nullable)())loginTipBlock{
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

/**
 *  根据页面类型得到跳转的页面URL，创建一个含有webview的控制器，将该控制器在当前navigationController中进栈
 *
 *  @param navigationController 导航控制器
 *  @param pageURL              页面路径
 */
+(void)reshipWebURLWithNavigationController:(UINavigationController*)navigationController pageURL:(NSString* _Nullable)pageURL{
    MDWebViewController *baseWebViewController = [[MDWebViewController alloc] init];
    baseWebViewController.requestURL = pageURL ;
    baseWebViewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:baseWebViewController animated:YES];
}

/*!
 *  解析指定的url，获取参数字典
 *
 *  @param url url
 *
 *  @return 参数字典
 */
+(NSDictionary*)urlParameterConvertDictionaryWithURL:(NSString*)url{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray * array = [url componentsSeparatedByString:@"?"];
    if(array.count != 2) return nil;
    array = [array[1] componentsSeparatedByString:@"&"];
    NSArray * tempArray;
    for (NSString *item in array) {
        tempArray = [item componentsSeparatedByString:@"="];
        if(![tempArray[0] isEqualToString:@""] && tempArray.count == 2){
            [dic setObject:tempArray[1] forKey:tempArray[0]];
        }
    }
    return dic;
}

/**
 *  通过指定的整型数值转化性别中文字符
 *
 *  @param value 整型数值
 *
 *  @return 中文字符
 */
+(NSString*)sexTextWithValue:(int)value{
    NSString *text = @"保密";
    switch(value){
        case 0:
            text = @"男";
            break;
        case 1:
            text = @"女";
            break;
    }
    return text;
}

/*!
 *  将默认的参数加入页面链接中
 *
 *  @param urlString 指定的页面链接
 *
 *  @return 页面链接
 */
+(NSString* _Nullable)appendParameterForAppWithURL:(NSString* _Nullable)urlString{
    NSString *paramString = @"";
    NSArray *array;
    NSString *resultURL = @"";
    if([urlString extensionWithContainsString:@"?"]){
        array = [urlString componentsSeparatedByString:@"?"];
        resultURL = array[0];
        paramString = array[1];
        
        array = [paramString componentsSeparatedByString:@"&"];
        paramString = @"";
        for (NSString *item in array) {
            if([item isEqualToString:@""] || [item extensionWithContainsString:@"token"] || [item extensionWithContainsString:@"phoneType"] || [item extensionWithContainsString:@"phoneSysVersion"]) continue;
            paramString = [NSString stringWithFormat:@"%@&%@",item,paramString];
        }
        
    }else{
        resultURL = urlString;
    }
    if(APPDATA.isLogin){
        paramString = [NSString stringWithFormat:@"%@=%@&%@",@"token",APPDATA.token,paramString];
    }
    paramString = [NSString stringWithFormat:@"%@=%@&%@",@"phoneType",@"ios",paramString];
    paramString = [NSString stringWithFormat:@"%@=%f&%@",@"phoneSysVersion",__IPHONE_SYSTEM_VERSION,paramString];
    return [NSString stringWithFormat:@"%@?%@",resultURL,paramString];
}

/*!
 *  检查版本
 */
+(void)checkedVersionForAppWithUpdateWithController:(UIViewController* _Nullable)controller isShowNewVersionMessage:(BOOL)isShowNewVersionMessage{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //推送更新
        NSString *query = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", AppID];
        query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
            if(results != nil){
                NSDictionary *dic = [[results objectForKey:@"results"] firstObject];
                NSString *version = [dic objectForKey:@"version"];
                if([version floatValue] > APP_VERSION){
                    [MDCommon showAlertUpdateVersionWithController:controller message:[NSString stringWithFormat:@"最新版本%@已经发布！",version]];
                }else{
                    if(isShowNewVersionMessage) [MDCommon showAlertWithController:controller message:@"当前版本已经是最新"];
                }
            }
        });
    });
}

/**
 *  根据指定的url来返回指定的controller对象
 *
 *  @param url               将要跳转的web页面地址
 *  @param currentController 当前controller
 *  @param token             用户token
 *
 *  @return controller对象
 */
+(UIViewController* _Nullable)controllerForPagePathWithURL:(NSString* _Nullable)url currentController:(UIViewController* _Nullable)currentController token:(NSString* _Nullable)token{
    NSString *title = @"";
    if([url extensionWithContainsString:PAGECONFIG.loginPageURLString]){//登陆
        return [[NSClassFromString(@"MDLoginViewController") alloc] init];
    } else if([url extensionWithContainsString:PAGECONFIG.homePageURLString]){//首页
        [currentController.navigationController popToRootViewControllerAnimated:NO];
        currentController.tabBarController.selectedIndex = tab_home_index;
        return nil;
    }else if([url extensionWithContainsString:PAGECONFIG.registerPageURLString]){
        title = @"注册";
    }else if([url extensionWithContainsString:PAGECONFIG.forgetPasswordPageURLString]){
        title = @"找回密码";
    }else if([url extensionWithContainsString:PAGECONFIG.categoryPageURLString]){//类目
        return [[NSClassFromString(@"MDClassesViewController") alloc] init];
    }else if([url extensionWithContainsString:PAGECONFIG.cartPageURLString]){
        title = @"购物车";
        return [[NSClassFromString(@"MDCartViewController") alloc] init];
    }else if([url extensionWithContainsString:PAGECONFIG.shopPageURLString]){//店铺
        currentController.tabBarController.selectedIndex = tab_shop_index;
        return nil;
    }else if([url extensionWithContainsString:PAGECONFIG.productDetailPageURLString]){
        title = @"商品详情";
    }else if([url extensionWithContainsString:PAGECONFIG.facePageURLString]){//面对面首页
        return [[NSClassFromString(@"MDFacesShopViewController") alloc] init];
    }else if([url extensionWithContainsString:PAGECONFIG.confirmOrderPageURLString]){
        title = @"订单确认";
    }else if([url extensionWithContainsString:PAGECONFIG.businessPresencePageURLString]){
        title = @"商家进驻";
    }else if([url extensionWithContainsString:PAGECONFIG.makeMoneyPageURLString]){
        title = @"我要赚钱";
    }else if([url extensionWithContainsString:PAGECONFIG.marketingPromotionPageURLString]){
        title = @"我要推广";
    }else if([url extensionWithContainsString:PAGECONFIG.downloadAppPageURLString]){
        title = @"下载App";
    }else if([url extensionWithContainsString:PAGECONFIG.hunredPercentPageURLString]){
        title = @"100%返利";
    }else if([url extensionWithContainsString:PAGECONFIG.cardPurchasePageURLString]){
        title = @"购物商机卡";
    }else if([url extensionWithContainsString:PAGECONFIG.receiveAddressPageURLString]){
        title = @"收货地址";
    }else if([url extensionWithContainsString:PAGECONFIG.cardConfirmPageURLString]){
        title = @"确认订单";
    }else if([url extensionWithContainsString:PAGECONFIG.collectionPageURLString]){
        title = @"收藏的商品/收藏的店铺";
    }else if([url extensionWithContainsString:PAGECONFIG.orderListPageURLString]){
        title = @"我的订单";
    }else if([url extensionWithContainsString:PAGECONFIG.walletPageURLString]){
        title = @"我的钱包";
    }else if([url extensionWithContainsString:PAGECONFIG.cardBalancePageURLString]){
        title = @"我的卡包";
    }else if([url extensionWithContainsString:PAGECONFIG.pointPageURLString]){
        title = @"我的积分";
    }else if([url extensionWithContainsString:PAGECONFIG.faceOrderPageURLString]){
        title = @"面对面支付";
    }else if([url extensionWithContainsString:PAGECONFIG.businessCardNavgPageURLString]){
        title = @"我的商机卡";
    }else if([url extensionWithContainsString:PAGECONFIG.businessCenterPageURLString]){
        title = @"商家中心";
    }else if([url extensionWithContainsString:PAGECONFIG.shopListPageURLString]){
        title = @"进入店铺";
    }else if([url extensionWithContainsString:PAGECONFIG.prodManagePageURLString]){
        title = @"商品管理";
    }else if([url extensionWithContainsString:PAGECONFIG.contactsPageURLString]){
        title = @"我的人脉";
    }else if([url extensionWithContainsString:PAGECONFIG.payPageURLString]){
        //title = @"订单支付";
        NSDictionary *dic = [MDCommon urlParameterForJsonWithURL:url];
        MDPaymentViewController *controller = [[MDPaymentViewController alloc] init];
        controller.orderType =[[dic objectForKey:@"orderType"] intValue];
        controller.orderCodes = [dic objectForKey:@"orderCodes"];
        return controller;
    }else if([url extensionWithContainsString:PAGECONFIG.happlyPurchasePageURLString]){
        title = @"快乐购";
    }else if([url extensionWithContainsString:PAGECONFIG.happlyPurchase2PageURLString]){
        title = @"快乐购";
    }else if([url extensionWithContainsString:PAGECONFIG.mdcollegePageURLString]){
        title = @"铭道学院";
    }else if([url extensionWithContainsString:PAGECONFIG.openCertificatePageURLString]){
        title = @"开通资格";
    }else if([url extensionWithContainsString:PAGECONFIG.accountSecurityPageURLString]){
        title = @"账户安全";
    }else if([url extensionWithContainsString:PAGECONFIG.alertLoginPWPageURLString]){
        title = @"修改登陆密码";
    }else if([url extensionWithContainsString:PAGECONFIG.alertPayPWPageURLString]){
        title = @"修改支付密码";
    }else if([url extensionWithContainsString:PAGECONFIG.cardRechargePageURLString]){
        MDRechargeViewController *controller = [[MDRechargeViewController alloc] init];
        controller.rechargeType = 1;
        return controller;
    }else if([url extensionWithContainsString:PAGECONFIG.walletRechargePageURLString]){
        MDRechargeViewController *controller = [[MDRechargeViewController alloc] init];
        controller.rechargeType = 2;
        return controller;
    }
    MDWebViewController *webViewController = [[MDWebViewController alloc] init];
    webViewController.navigateTitle = title;
    webViewController.requestURL = url;
    return webViewController;
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

/*!
 *  将指定的url字符串的所有参数转换成指定的参数字典
 *
 *  @param urlString url字符串
 *
 *  @return 参数字典
 */
+(NSDictionary*)urlParameterForJsonWithURL:(NSString*)urlString{
    NSString *resultString = [urlString substringFromIndex:[urlString rangeOfString:@"?"].location+1];
    resultString = [NSString stringWithFormat:@"{\"%@\"}",[resultString stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""]];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[resultString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

+(void)showAlertUpdateVersionWithController:(UIViewController*)controller message:(NSString*)message {
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MDCommon UpdateVersion];
        }]];
        [controller presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:[MDCommonDelegate sharedMDCommon] cancelButtonTitle:@"知道了" otherButtonTitles:@"前往更新",nil];
        [alertView show];
    }
}

+(void)showAlertWithController:(UIViewController*)controller message:(NSString*)message {
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [controller presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

+(void)UpdateVersion{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/ming-dao-chao-zhi-gou/id%@?l=zh&ls=1&mt=8",AppID]]];
}

@end
