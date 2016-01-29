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


@interface MDShopInformationModel : NSObject
//店招图片地址
@property(strong,nonatomic) NSString *shopNavigationPic;
//店铺名称
@property(strong,nonatomic) NSString *shopName;
//店铺logo图片地址
@property(strong,nonatomic) NSString *shopLogo;
//店铺区域
@property(strong,nonatomic) NSString *address;
//街道地址
@property(strong,nonatomic) NSString *street;
//客服qq
@property(strong,nonatomic) NSString *serviceQq;
//客服电话
@property(strong,nonatomic) NSString *serviceTel;
//营业时间
@property(strong,nonatomic) NSString *businessHours;
//省名
@property(strong,nonatomic) NSString *provinceName;
//市名
@property(strong,nonatomic) NSString *cityName;
//区名
@property(strong,nonatomic) NSString *countyName;

@end
