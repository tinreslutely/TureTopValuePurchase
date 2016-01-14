//
//  MDHomeModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDHomeRenovateChannelDetailModel : NSObject

@property(nonatomic,assign) int columnId;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *contentAddr;//内容地址--图片路径
@property(nonatomic,assign) int contentId;
@property(nonatomic,strong) NSString *picAddr;

@end

@interface MDHomeRenovateChannelModel : NSObject

@property(nonatomic,assign) int carrierType;
@property(nonatomic,strong) NSArray<MDHomeRenovateChannelDetailModel*> *channelColumnDetails;
@property(nonatomic,assign) int channelType;
@property(nonatomic,strong) NSString *columnLink;
@property(nonatomic,strong) NSString *columnName;
@property(nonatomic,assign) int columnSort;
@property(nonatomic,assign) int columnType;
@property(nonatomic,assign) int shopId;
@end


@interface MDHomeRenovateModel : NSObject

@property(nonatomic,assign) BOOL state;
@property(nonatomic,strong) NSString *stateCode;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSMutableArray<MDHomeRenovateChannelModel *> *list;

@end

@interface MDHomeModel : NSObject

@end
