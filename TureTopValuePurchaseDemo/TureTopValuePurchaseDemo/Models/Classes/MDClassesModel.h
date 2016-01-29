//
//  MDClassesModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/23.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDClassesModel : NSObject

//0:超值购,1:天天特卖,2:热卖,3:小平台类
@property(nonatomic,assign) int categoryType;
//创建时间
@property(nonatomic,strong) NSDate *createTime;
//类别id
@property(nonatomic,assign) long id;
//父级id
@property(nonatomic,assign) int parentTypeId;
//类别名
@property(nonatomic,strong) NSString *sysTypeName;
//合伙人id
@property(nonatomic,assign) int partnerUserId;
//修改时间
@property(nonatomic,strong) NSDate *modifyTime;
//修改人
@property(nonatomic,assign) int modifyUser;
//类别id
@property(nonatomic,assign) int typeId;
//排序
@property(nonatomic,assign) int sort;
//下级类别列表
@property(nonatomic,strong) NSArray *secondTypes;
//
@property(nonatomic,assign) int isValid;
//类目等级
@property(nonatomic,assign) int typeLevel;
//图标地址
@property(nonatomic,strong) NSString *typeCover;

@end
