//
//  MDPaymentDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDPaymentModel.h"
#import "MDSubmitPaymentOrderModel.h"
#import "MDPaymentOrderInformationModel.h"

@interface MDPaymentDataController : NSObject

-(void)requestOrderDataWithUserId:(NSString* _Nullable)userId orderCodes:(NSString* _Nullable)orderCodes orderType:(NSString* _Nullable)orderType completion:(void(^ _Nullable)(BOOL state, NSString * _Nullable msg, MDPaymentOrderInformationModel * _Nullable model))completion;

-(void)submitPaymentOrderWithUserId:(NSString* _Nullable)userId orderCodes:(NSString* _Nullable)orderCodes orderType:(MDOrderType)ordertype payType:(MDPaymentType)paytype cardPayAmount:(NSString* _Nullable)cardPayAmount payPwd:(NSString* _Nullable)payPwd completion:(void(^ _Nullable )(BOOL state, NSString * _Nullable msg, MDSubmitPaymentOrderModel * _Nullable model))completion;

-(void)cancelPaymentWithUserId:(NSString* _Nullable)userId mergeCode:(NSString* _Nullable)mergeCode completion:(void(^ _Nullable)(BOOL state, NSString *  _Nullable msg))completion;

-(void)requestWalletCardBalanceDataWithUserId:(NSString* _Nullable)userId type:(MDBalanceType)type completion:(void(^ _Nullable)(BOOL state, NSString * _Nullable msg, MDPaymentModel * _Nullable model))completion;

-(void)submitCardRechargeWithRechargeType:(MDRechargeType)rechargeType userId:(NSString* _Nullable)userId payType:(int)payType payAmount:(float)payAmount payPwd:(NSString* _Nullable)payPwd completion:(void(^ _Nullable)(BOOL state, NSString *  _Nullable msg, MDSubmitPaymentOrderModel *  _Nullable model))completion;

-(void)cancelPaymentWithUserId:(NSString* _Nullable)userId mergeCode:(NSString*)mergeCode completion:(void(^ _Nullable)(BOOL state, NSString * _Nullable msg))completion;
@end
