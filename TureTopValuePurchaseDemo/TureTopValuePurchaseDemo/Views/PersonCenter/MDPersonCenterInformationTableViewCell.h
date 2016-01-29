//
//  MDPersonCenterInformationTableViewCell.h
//  TureTopValuePurchaseDemo
//  个人中心 - 显示头像、用户名、用户角色、收藏商品、收藏店铺等信息的UITableViewCell扩展类
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPersonCenterInformationTableViewCell : UITableViewCell

@property(nonatomic,strong,nullable) UIImageView *headImageView;//显示头像控件
@property(nonatomic,strong,nullable) UIButton *nameButton;//显示用户名控件
@property(nonatomic,strong,nullable) UIImageView *roleImageView;//显示角色标示控件
@property(nonatomic,strong,nullable) UIButton *roleButton;//显示用户角色名称控件

@property(nonatomic,strong,nullable) UIControl *consigneeProductControl;//收藏商品控件
@property(nonatomic,strong,nullable) UIControl *consigneeShopControl;//收藏店铺控件
@property(nonatomic,strong,nullable) UILabel *consigneeShopLabel;//显示收藏店铺数量控件
@property(nonatomic,strong,nullable) UILabel *consigneeProductLabel;//显示收藏商品数量控件

@property(nonatomic,strong,nullable) UIButton *detailButton;//跳转详情按钮控件

@end
