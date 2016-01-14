//
//  MDHomeDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDHomeModel.h"
#import "ImageCarouselView.h"
#import "SDCycleScrollView.h"

@interface MDHomeDataController : NSObject<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,ImageCarouselViewDelegate>

-(void)refreshDataWithCompletion:(void(^)(BOOL state))completion;

@property(nonatomic,copy) void (^scrollBlock)(float scrollY);
@end
