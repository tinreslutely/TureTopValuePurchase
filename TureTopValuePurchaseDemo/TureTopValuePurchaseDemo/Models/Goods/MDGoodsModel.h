//
//  MDGoodsModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/2.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDGoodsModel : NSObject

//商品编号
@property(strong,nonatomic) NSString *productId;
//商品名称
@property(strong,nonatomic) NSString *productName;
//供货价
@property(assign,nonatomic) double supplyPrice;
//商品类型  商品类型:0 超值购，1天天特卖
@property(assign,nonatomic) int productType;
//商品图片
@property(strong,nonatomic) NSString *prodMainPicUrl;
//商家电话
@property(strong,nonatomic) NSString *sellerPhone;
//返卡包
@property(assign,nonatomic) double rebateAmount;
//商品分类编号
@property(strong,nonatomic) NSString *categoryId;
//销量
@property(assign,nonatomic) int saleQty;
//用户编号
@property(assign,nonatomic) int sellerId;
//市场价
@property(assign,nonatomic) double price;
//销售价
@property(assign,nonatomic) double salesPrice;
//是否包邮 1是，0否
@property(assign,nonatomic) int isPinkage;
//店铺编号
@property(strong,nonatomic) NSString *shopId;
//店铺名称
@property(strong,nonatomic) NSString *shopName;

@end

@interface MDProductModel : NSObject

//商品编号
@property(strong,nonatomic) NSString *productId;
//商品名称
@property(strong,nonatomic) NSString *productName;
//供货价
@property(assign,nonatomic) double supplyPrice;
//商品类型  商品类型:0 超值购，1天天特卖
@property(assign,nonatomic) int productType;
//商品图片
@property(strong,nonatomic) NSString *prodMainPicUrl;
//商家电话
@property(strong,nonatomic) NSString *sellerPhone;
//返卡包
@property(assign,nonatomic) double rebateAmount;
//商品分类编号
@property(strong,nonatomic) NSString *categoryId;
//销量
@property(assign,nonatomic) int saleQty;
//用户编号
@property(assign,nonatomic) int sellerId;
//市场价
@property(assign,nonatomic) double price;
//销售价
@property(assign,nonatomic) double salesPrice;
//是否包邮 1是，0否
@property(assign,nonatomic) int isPinkage;
//店铺编号
@property(strong,nonatomic) NSString *shopId;
//店铺名称
@property(strong,nonatomic) NSString *shopName;

@end

//商品列表数据模型
@interface MDProductListModel : NSObject

//状态
@property(assign,nonatomic) BOOL state;
//状态请求码
@property(strong,nonatomic) NSString *stateCode;
//提示消息
@property(strong,nonatomic) NSString *message;

@property(strong,nonatomic) NSMutableArray *result;
@property(strong,nonatomic) NSString *inverseOrder;
@property(assign,nonatomic) int pageSize;
@property(assign,nonatomic) int totalCount;
@property(assign,nonatomic) int totalPages;
@property(assign,nonatomic) BOOL hasNext;
@property(assign,nonatomic) int nextPage;
@property(assign,nonatomic) BOOL hasPre;
@property(assign,nonatomic) int prePage;
@property(assign,nonatomic) int first;
@property(assign,nonatomic) BOOL pageSizeSetted;
@property(assign,nonatomic) BOOL orderBySetted;
@property(strong,nonatomic) NSString *order;
@property(assign,nonatomic) int pageNo;
@property(strong,nonatomic) NSString *orderBy;
@property(assign,nonatomic) BOOL firstSetted;
@property(assign,nonatomic) BOOL autoCount;

-(NSDictionary*)dictionaryForRequestWithPageNo:(int)pageno pageSize:(int)pagesize keywords:(NSString*)keywords categoryId:(int)categoryId shopId:(int)shopId productType:(NSString*)productType sort:(int)sort;
-(void)convertWithData:(id)data;

@end