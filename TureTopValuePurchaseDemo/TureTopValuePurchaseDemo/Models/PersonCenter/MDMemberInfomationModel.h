//
//  MDMemberInfomationModel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMemberInfomationModel : NSObject
//头像地址
@property(strong,nonatomic) NSString *headPortrait;
//手机号
@property(strong,nonatomic) NSString *phone;
//昵称
@property(strong,nonatomic) NSString *nickName;
//性别
@property(assign,nonatomic) int sex;
//区域
@property(strong,nonatomic) NSString *area;
//真实姓名
@property(strong,nonatomic) NSString *realname;
//固定电话
@property(strong,nonatomic) NSString *tel;
//邮箱
@property(strong,nonatomic) NSString *email;
@end
