//
//  MDPaymentDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDPaymentDataController.h"

@implementation MDPaymentDataController

/*!
 *  获取订单支付信息
 *
 *  @param userId       用户Id
 *  @param orderCodes   订单编号
 *  @param orderType    订单类型
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 */
-(void)requestOrderDataWithUserId:(NSString* _Nullable)userId orderCodes:(NSString* _Nullable)orderCodes orderType:(NSString* _Nullable)orderType completion:(void(^ _Nullable)(BOOL state, NSString * _Nullable msg, MDPaymentOrderInformationModel * _Nullable model))completion{
    [MDHttpManager GET:APICONFIG.paymentOrderInformationApiURLString parameters:@{@"userId":userId,@"orderCodes":orderCodes,@"orderType":orderType} sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        MDPaymentOrderInformationModel *model = [MDPaymentOrderInformationModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        completion(YES, nil, model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  提交支付订单
 *
 *  @param userId        用户Id
 *  @param orderCodes    订单编号
 *  @param ordertype     订单类型
 *  @param paytype       支付类型
 *  @param cardPayAmount 卡包支付金额
 *  @param payPwd        支付密码
 *  @param completion    完成回调
 */
-(void)submitPaymentOrderWithUserId:(NSString* _Nullable)userId orderCodes:(NSString* _Nullable)orderCodes orderType:(MDOrderType)ordertype payType:(MDPaymentType)paytype cardPayAmount:(NSString* _Nullable)cardPayAmount payPwd:(NSString* _Nullable)payPwd completion:(void(^ _Nullable )(BOOL state, NSString * _Nullable msg, MDSubmitPaymentOrderModel * _Nullable model))completion{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"userId":userId,@"orderCodes":orderCodes,@"orderType":[NSString stringWithFormat:@"%ld",(long)ordertype],@"payType":[NSString stringWithFormat:@"%ld",(long)paytype]}];
    if(paytype == MDPaymentTypeSystempay){
        [dic setObject:cardPayAmount forKey:@"cardPayAmount"];
        [dic setObject:payPwd forKey:@"payPwd"];
    }
    [MDHttpManager POST:APICONFIG.submitpaymentOrderApiURLString parameters:dic sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        MDSubmitPaymentOrderModel *model;
        if([[dic objectForKey:@"result"] isKindOfClass:[NSDictionary class]]){
            model = [MDSubmitPaymentOrderModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        }else{
            model = [[MDSubmitPaymentOrderModel alloc] init];
            model.payURL = [dic objectForKey:@"result"];
        }
        completion(YES, nil, model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  取消支付订单
 *
 *  @param userId       用户id
 *  @param mergeCode    合并订单号
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 */
-(void)cancelPaymentWithUserId:(NSString* _Nullable)userId mergeCode:(NSString* _Nullable)mergeCode completion:(void(^ _Nullable)(BOOL state, NSString *  _Nullable msg))completion{
    [MDHttpManager POST:APICONFIG.cancelPaymentOrderApiURLString parameters:@{@"userId":userId,@"mergeCode":mergeCode}  sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error]);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"]);
            return;
        }
        completion(YES,[dic objectForKey:@"result"]);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error]);
    }];
}

/*!
 *  获取电子钱包或卡包余额
 *
 *  @param userId       用户id
 *  @param type         账户类型  1-卡包余额  2-电子钱包
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 */
-(void)requestWalletCardBalanceDataWithUserId:(NSString* _Nullable)userId type:(MDBalanceType)type completion:(void(^ _Nullable)(BOOL state, NSString * _Nullable msg, MDPaymentModel * _Nullable model))completion{
    [MDHttpManager GET:(type == MDBalanceTypeCard ? APICONFIG.cardBalanceApiURLString : APICONFIG.walletBalanceApiURLString) parameters:@{@"userId":userId}  sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        MDPaymentModel *model = [MDPaymentModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        completion(YES,[dic objectForKey:@"result"],model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

/*!
 *  电子钱包或卡包充值
 *
 *  @param rechargeType 充值类型  1-卡包余额  2-电子钱包
 *  @param userId       用户id
 *  @param payType      支付类型
 *  @param payAmount    支付金额
 *  @param payPwd       支付密码
 *  @param completion   完成回调
 */
-(void)submitCardRechargeWithRechargeType:(MDRechargeType)rechargeType userId:(NSString* _Nullable)userId payType:(int)payType payAmount:(float)payAmount payPwd:(NSString* _Nullable)payPwd completion:(void(^ _Nullable)(BOOL state, NSString *  _Nullable msg, MDSubmitPaymentOrderModel *  _Nullable model))completion{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"userId":userId,@"payType":[NSString stringWithFormat:@"%d",payType],@"payAmount":[NSString stringWithFormat:@"%f",payAmount]}];
    if(payType == MDPaymentTypeSystempay) [dic setObject:payPwd forKey:@"payPwd"];
    [MDHttpManager POST:(rechargeType == MDRechargeTypeCard ? APICONFIG.cardRechargeApiURLString : APICONFIG.walletRechargeApiURLString) parameters:dic  sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        MDSubmitPaymentOrderModel *model = [MDSubmitPaymentOrderModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        completion(YES,[dic objectForKey:@"result"],model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}

@end
