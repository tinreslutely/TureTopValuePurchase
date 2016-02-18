//
//  MDShopSearchModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/18.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDShopSearchModel : NSObject

//店铺名
@property(strong,nonatomic) NSString *shopName;
//店铺ID
@property(assign,nonatomic) int shopId;
//店铺地址
@property(strong,nonatomic) NSString *shopAddr;
//店招
@property(strong,nonatomic) NSString *shopNavigationPic;
//店铺logo
@property(strong,nonatomic) NSString *shopLogo;
//省份
@property(strong,nonatomic) NSString *provinceName;
//城市
@property(strong,nonatomic) NSString *cityName;
//地区
@property(strong,nonatomic) NSString *countyName;

@end
