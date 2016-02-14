//
//  MDFacesShopAreaModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDFacesShopAreaModel : NSObject

/**
 *  地区名称
 */
@property(strong,nonatomic) NSString *areaName;

/**
 *  地区编码
 */
@property(strong,nonatomic) NSString *areaCode;

/**
 *  类别  city城市 county区县
 */
@property(strong,nonatomic) NSString *type;

/**
 *  店铺数量统计
 */
@property(assign,nonatomic) int shopCount;

@end
