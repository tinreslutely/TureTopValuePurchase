//
//  MDShopModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/25.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDShopModel : NSObject

@property(assign,nonatomic) BOOL hasShop;//是否拥有店铺

@property(assign,nonatomic) int shopId;//店铺id

@property(strong,nonatomic) NSString *shopName;//店铺名称

@property(assign,nonatomic) int salesNum;//总销量

@property(strong,nonatomic) NSString *shopLogo;//店铺logo图片地址

@end
