//
//  MDFacesShopCategoryModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDFacesShopCategoryModel : NSObject

/**
 *  分类id
 */
@property(assign,nonatomic) int id;

/**
 *  分类名称
 */
@property(strong,nonatomic) NSString *industryName;

/**
 *  父级分类id
 */
@property(assign,nonatomic) int parentTypeId;

/**
 *  分类级别
 */
@property(assign,nonatomic) int typeLevel;

/**
 *  图片地址
 */
@property(strong,nonatomic) NSString *typeCover;

@end
