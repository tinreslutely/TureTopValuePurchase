//
//  MDShopSearchManyCollectionViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/18.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopSearchManyCollectionViewCell.h"

@implementation MDShopSearchManyCollectionViewCell

@synthesize imageView,titleLabel,areaLabel;

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        int imageSize = frame.size.width-16;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, imageSize, imageSize)];
        [self.contentView addSubview:imageView];
        
        //店铺名称
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, imageSize+8, frame.size.width - 16, 40)];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor grayColor]];
        [titleLabel setNumberOfLines:2];
        [self.contentView addSubview:titleLabel];
        
        //店铺地区
        areaLabel = [[UILabel alloc]  initWithFrame:CGRectMake(8, imageSize+48, frame.size.width - 16, 25)];
        [areaLabel setFont:[UIFont systemFontOfSize:12]];
        [areaLabel setTextColor:[UIColor redColor]];
        [self.contentView addSubview:areaLabel];
    }
    return self;
}

@end
