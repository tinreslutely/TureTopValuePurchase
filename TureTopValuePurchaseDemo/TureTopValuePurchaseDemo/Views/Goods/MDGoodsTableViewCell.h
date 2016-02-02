//
//  MDGoodsTableViewCell.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/2.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface MDGoodsTableViewCell : SWTableViewCell

@property(strong,nonatomic) UIImageView *imageView;
@property(strong,nonatomic) UILabel *titleLabel;
@property(strong,nonatomic) UILabel *sellPriceLabel;
@property(strong,nonatomic) UILabel *marketPriceLabel;
@property(strong,nonatomic) UILabel *payBackPriceLabel;

@end
