//
//  MDGoodsTableViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/2.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDGoodsTableViewCell.h"

@implementation MDGoodsTableViewCell


@synthesize imageView,titleLabel,sellPriceLabel,marketPriceLabel,payBackPriceLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self.contentView addSubview:imageView];
        
        //商品标题
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 110, 40)];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor grayColor]];
        [titleLabel setNumberOfLines:2];
        [self.contentView addSubview:titleLabel];
        
        //销售价格
        sellPriceLabel = [[UILabel alloc]  initWithFrame:CGRectMake(100, 50, 110, 25)];
        [sellPriceLabel setFont:[UIFont systemFontOfSize:16]];
        [sellPriceLabel setTextColor:[UIColor redColor]];
        [self.contentView addSubview:sellPriceLabel];
    }
    return self;
}


@end
