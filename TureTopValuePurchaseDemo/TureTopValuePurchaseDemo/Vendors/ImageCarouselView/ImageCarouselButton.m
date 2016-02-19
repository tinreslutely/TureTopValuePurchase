//
//  ImageCarouselButton.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/19.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "ImageCarouselButton.h"

@implementation ImageCarouselButton

@synthesize imageView,titleLabel;

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
        [titleLabel setBackgroundColor:UIColorFromRGBA(154,154, 154, 0.5)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        [self bringSubviewToFront:titleLabel];
    }
    return self;
}

@end
