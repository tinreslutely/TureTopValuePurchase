//
//  MDGoodsManyCollectionViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/3.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDGoodsManyCollectionViewCell.h"

@implementation MDGoodsManyCollectionViewCell

@synthesize imageView,titleLabel,sellPriceLabel;
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        int imageSize = frame.size.width-16;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, imageSize, imageSize)];
        [self.contentView addSubview:imageView];
        
        //商品标题
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, imageSize+8, frame.size.width - 16, 40)];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor grayColor]];
        [titleLabel setNumberOfLines:2];
        [self.contentView addSubview:titleLabel];
        
        //销售价格
        sellPriceLabel = [[UILabel alloc]  initWithFrame:CGRectMake(8, imageSize+48, frame.size.width - 16, 25)];
        [sellPriceLabel setFont:[UIFont systemFontOfSize:16]];
        [sellPriceLabel setTextColor:[UIColor redColor]];
        [self.contentView addSubview:sellPriceLabel];
    }
    return self;
}

@end
