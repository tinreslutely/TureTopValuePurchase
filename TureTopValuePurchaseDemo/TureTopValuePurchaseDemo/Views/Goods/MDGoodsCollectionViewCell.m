//
//  MDGoodsCollectionViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/3.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDGoodsCollectionViewCell.h"

@implementation MDGoodsCollectionViewCell

@synthesize imageView,titleLabel,sellPriceLabel;
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
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
        
        UILabel *spaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, frame.size.height-0.5, frame.size.width-8, 0.5)];
        [spaceLabel setBackgroundColor:UIColorFromRGBA(220, 220, 220, 1)];
        [self.contentView addSubview:spaceLabel];
        
    }
    return self;
}

@end
