//
//  MDHomeRedShopTableViewCell.h
//  TureTopValuePurchaseDemo
//  首页-推荐店铺视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCarouselView.h"

@interface MDHomeRedShopTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) ImageCarouselView *imageScrollView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<ImageCarouselViewDelegate>)delegate;

@end
