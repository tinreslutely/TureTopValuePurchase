//
//  MDPaymentOrderInformationModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDPaymentOrderInformationModel : NSObject

@property(nonatomic,assign) float walletBalance;//电子钱包余额
@property(nonatomic,assign) BOOL canUseCardPay;//是否可以使用卡包支付
@property(nonatomic,assign) float cardBalance;//卡包余额
@property(nonatomic,assign) float totalPrice;//订单总价
@property(nonatomic,assign) BOOL hasEnoughWalletPay;//是否允许使用电子钱包支付
@property(nonatomic,assign) BOOL hasEnoughCardPay;//是否有足够的卡包金额支付
@property(nonatomic,assign) float shortCardPrice;//还需卡包金额

@end
