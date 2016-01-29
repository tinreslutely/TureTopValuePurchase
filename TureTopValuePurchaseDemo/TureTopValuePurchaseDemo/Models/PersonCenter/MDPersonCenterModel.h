//
//  MDPersonCenterModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDPersonCenterModel : NSObject

//用户昵称
@property(strong,nonatomic) NSString *nickName;
//头像地址
@property(strong,nonatomic) NSString *headPortrait;
//用户角色
@property(strong,nonatomic) NSString *userRoles;
//商品收藏数
@property(assign,nonatomic) long productCollectionCount;
//店铺收藏数
@property(assign,nonatomic) long shopCollectionCount;
//待款数
@property(assign,nonatomic) long orderUnpaid;
//已付款，待发货
@property(assign,nonatomic) long orderPaid;
//待收货
@property(assign,nonatomic) long orderDelivered;
//待评价
@property(assign,nonatomic) long notComment;
//可用余额
@property(assign,nonatomic) double balance;
//冻结金额
@property(assign,nonatomic) double frozeAmount;
//累计收益
@property(assign,nonatomic) double earnTotal;
//卡包金额
@property(assign,nonatomic) double cardBalance;
//我的积分
@property(assign,nonatomic) double pointBalance;

@end
