//
//  MDShopSearchCollectionViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/18.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopSearchCollectionViewCell.h"

@implementation MDShopSearchCollectionViewCell

@synthesize imageView,titleLabel,areaLabel;

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self.contentView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH - 90, 40)];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:titleLabel];
        
        areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 45, 120, 25)];
        [areaLabel setFont:[UIFont systemFontOfSize:12]];
        [areaLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:areaLabel];
        
        
        UILabel *spaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, frame.size.height-0.5, frame.size.width-8, 0.5)];
        [spaceLabel setBackgroundColor:UIColorFromRGBA(220, 220, 220, 1)];
        [self.contentView addSubview:spaceLabel];
    }
    return self;
}
@end
