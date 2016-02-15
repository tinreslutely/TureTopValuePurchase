//
//  MDUploadPicModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDUploadPicModel : NSObject

//用于显示图片
@property(strong,nonatomic) NSString *absoluteUrl;
//保存在数据库
@property(strong,nonatomic) NSString *relativeUrl;

@end
