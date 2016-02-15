//
//  MDSubmitPaymentOrderModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSubmitPaymentOrderModel : NSObject

@property(nonatomic,strong) NSString *payURL;
@property(nonatomic,strong) NSString *appid;
@property(nonatomic,strong) NSString *partnerid;
@property(nonatomic,strong) NSString *prepayid;
@property(nonatomic,strong) NSString *timestamp;
@property(nonatomic,strong) NSString *noncestr;
@property(nonatomic,strong) NSString *package;
@property(nonatomic,strong) NSString *sign;
@property(nonatomic,assign) int attach;
@property(nonatomic,strong) NSString *out_trade_no;// 合并单号
@property(nonatomic,strong) NSString *mergeCode;// 合并单编号
@property(nonatomic,assign) int orderType;
@property(nonatomic,assign) BOOL isFirst;

@end
