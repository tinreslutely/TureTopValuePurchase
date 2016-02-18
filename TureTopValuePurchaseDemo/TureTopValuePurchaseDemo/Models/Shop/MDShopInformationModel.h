//
//  MDShopInformationModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/17.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

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
