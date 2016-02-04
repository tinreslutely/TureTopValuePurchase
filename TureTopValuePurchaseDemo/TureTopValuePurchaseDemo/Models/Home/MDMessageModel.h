//
//  MDMessageModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/4.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMessageModel : NSObject

@property(assign,nonatomic) int id;//编号
@property(assign,nonatomic) int receiveId;//接收人Id
@property(assign,nonatomic) int senderId;//发送人Id
@property(assign,nonatomic) int isRead;//是否已读
@property(strong,nonatomic) NSString *createTime;//发送时间
@property(strong,nonatomic) NSString *title;//消息标题
@property(strong,nonatomic) NSString *content;//消息内容

@end
