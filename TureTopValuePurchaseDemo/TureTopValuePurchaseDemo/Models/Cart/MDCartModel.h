//
//  MDCartModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/25.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDCartModel : NSObject

@property(assign,nonatomic) int cartId;
@property(strong,nonatomic) NSString *cartKey;
@property(strong,nonatomic) NSString *mainPic;
@property(assign,nonatomic) int productId;
@property(strong,nonatomic) NSString *productName;
@property(assign,nonatomic) int qty;
@property(assign,nonatomic) float salesPrice;
@property(strong,nonatomic) NSString *skuAttr;
@property(assign,nonatomic) int skuId;

@end

@interface MDCartShopModel : NSObject

@property(assign,nonatomic) int shopId;
@property(strong,nonatomic) NSString *shopName;
@property(strong,nonatomic) NSArray *products;
@end