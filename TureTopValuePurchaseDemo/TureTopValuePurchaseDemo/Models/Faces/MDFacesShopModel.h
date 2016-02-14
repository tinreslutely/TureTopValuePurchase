//
//  MDFacesShopModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/8.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDFacesShopModel : NSObject

/**
 *  位置(显示公里数)
 */
@property(strong,nonatomic) NSString *position;

/**
 *  距离
 */
@property(assign,nonatomic) int distance;

/**
 *  行业名称
 */
@property(strong,nonatomic) NSString *industryName;

/**
 *  赠送比例
 */
@property(assign,nonatomic) int returnRatio;

/**
 *  店铺名称
 */
@property(strong,nonatomic) NSString *companyName;

/**
 *  用户id
 */
@property(assign,nonatomic) int userId;

/**
 *  店铺id
 */
@property(assign,nonatomic) int shopId;

/**
 *  街道名称
 */
@property(strong,nonatomic) NSString *streetName;

/**
 *  图片
 */
@property(strong,nonatomic) NSString *logo;

@end
