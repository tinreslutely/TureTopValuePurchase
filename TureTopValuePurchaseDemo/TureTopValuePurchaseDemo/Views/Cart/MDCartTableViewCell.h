//
//  MDCartTableViewCell.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/7.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <SWTableViewCell/SWTableViewCell.h>
#import "CheckBoxButton.h"
#import "NumberBoxView.h"

@interface MDCartTableViewCell : SWTableViewCell

@property(nonatomic,strong,nullable,readonly) CheckBoxButton *checkButton;//选择控件
@property(nonatomic,strong,nullable,readonly) UIImageView *imageView;//图片控件
@property(nonatomic,strong,nullable,readonly) UILabel *titleLabel;//标题控件
@property(nonatomic,strong,nullable,readonly) UILabel *propertyLabel;//价格控件
@property(nonatomic,strong,nullable,readonly) UILabel *priceLabel;//价格控件
@property(nonatomic,strong,nullable,readonly) NumberBoxView *numberBoxView;//数量选择器

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate;
@end
