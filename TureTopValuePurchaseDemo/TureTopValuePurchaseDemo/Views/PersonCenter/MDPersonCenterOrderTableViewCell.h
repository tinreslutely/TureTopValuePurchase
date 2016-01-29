//
//  MDPersonCenterOrderTableViewCell.h
//  TureTopValuePurchaseDemo
//  订单状态（待付款、待发货、待收货、待评价）的订单查询的UITableViewCell扩展类
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13BadgeView.h"

@interface MDPersonCenterOrderTableViewCell : UITableViewCell

@property (nonatomic,strong,nullable)M13BadgeView * noPaidBadge;//未付款
@property (nonatomic,strong,nullable)M13BadgeView * noDispatchBadge;//未发货
@property (nonatomic,strong,nullable)M13BadgeView * noConsigneeBadge;//未收货
@property (nonatomic,strong,nullable)M13BadgeView * noEvalBadge;//未评价

@end
