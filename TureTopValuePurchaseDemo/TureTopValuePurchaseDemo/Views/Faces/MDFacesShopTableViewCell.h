//
//  MDFacesShopTableViewCell.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDFacesShopTableViewCell : UITableViewCell

@property(nonatomic,strong,nullable) UIImageView *imageView;//店铺logo
@property(nonatomic,strong,nullable) UILabel *positionLabel;//店铺位置
@property(nonatomic,strong,nullable) UILabel *titleLabel;//店铺名称
@property(nonatomic,strong,nullable) UILabel *subLabel;//店铺副标题
@property(nonatomic,strong,nullable) UILabel *typeLabel;//店铺类型

@end
