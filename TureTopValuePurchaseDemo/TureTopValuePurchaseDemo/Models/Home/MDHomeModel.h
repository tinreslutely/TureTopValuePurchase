//
//  MDHomeModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDHomeRenovateChannelDetailModel : NSObject

@property(nonatomic,assign) int columnId;//模块ID
@property(nonatomic,strong) NSString *contentAddr;//内容地址
@property(nonatomic,assign) int contentId;//内容ID
@property(nonatomic,strong) NSString *content;//内容
@property(nonatomic,strong) NSString *picAddr;//图片路径

@end

@interface MDHomeRenovateChannelModel : NSObject

@property(nonatomic,strong) NSArray<MDHomeRenovateChannelDetailModel*> *channelColumnDetails;
@property(nonatomic,strong) NSString *columnName;//模块名
@property(nonatomic,strong) NSString *columnLink;//模块跳转链接
@property(nonatomic,assign) int columnType;//模块类型
@end


@interface MDHomeRenovateModel : NSObject

@property(nonatomic,assign) BOOL state;
@property(nonatomic,strong) NSString *stateCode;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSMutableArray<MDHomeRenovateChannelModel *> *list;

@end


@interface MDHomeLikeProductModel : NSObject

@property(nonatomic,strong) NSString *imageURL;
@property(nonatomic,assign) int productId;
@property(nonatomic,assign) int shopId;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) float sellPirce;

@end


@interface MDHomeLikeProductsModel : NSObject

@property(nonatomic,assign) BOOL state;
@property(nonatomic,strong) NSString *stateCode;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSMutableArray *list;

@end

@interface MDHomeModel : NSObject

@end
