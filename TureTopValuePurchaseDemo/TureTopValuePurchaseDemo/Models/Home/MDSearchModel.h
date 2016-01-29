//
//  MDSearchModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/28.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSearchModel : NSObject

@property(nonatomic,strong) NSString *keyword;
@property(nonatomic,assign) int type;
@property(nonatomic,strong) NSDate *datetime;

@end
