//
//  MDPersonCenterAccountTableViewCell.h
//  TureTopValuePurchaseDemo
//  用户账户信息（可用余额、冻结余额）的UITableViewCell扩展类
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPersonCenterAccountTableViewCell : UITableViewCell

@property(nonatomic,strong,nullable) UILabel *freezeMoneyLabel;//可用余额显示控件
@property(nonatomic,strong,nullable) UILabel *noneFreezeMoneyLabel;//冻结余额显示控件

@end
