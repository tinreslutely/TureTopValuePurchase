//
//  MDClassesDataController.h
//  TureTopValuePurchaseDemo
//  产品类目数据控制器
//  Created by 李晓毅 on 16/1/23.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDClassesModel.h"

@interface MDClassesDataController : NSObject

-(void)requestFirstDataWithCompletion:(void(^)(BOOL state, NSString *msg, NSArray<MDClassesModel*> *list))completion;
-(void)requestSecondDataWithTypeId:(int)typeId cType:(int)cType completion:(void(^)(BOOL state, NSString *msg, NSArray<MDClassesModel*> *list))completion;
@end
