//
//  ImageCarouselViewCell.m
//  SDCycleScrollView
//
//  Created by 李晓毅 on 15/12/1.
//  Copyright © 2015年 GSD. All rights reserved.
//

#import "ImageCarouselViewCell.h"

@implementation ImageCarouselViewCell

@synthesize imageCarouseControl,imageView,titleLabel,imageCarouseId;


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    float pointX = 0;
    float width = self.frame.size.width/3;
    [self brindSubViewForControlWithPointX:pointX width:width];
    pointX += width;
    [self brindSubViewForControlWithPointX:pointX width:width];
    pointX += width;
    [self brindSubViewForControlWithPointX:pointX width:width];
}

-(void) brindSubViewForControlWithPointX:(float)pointX width:(float)width{
    
    imageCarouseControl = [[UIControl alloc] initWithFrame:CGRectMake(pointX, 0, width, self.frame.size.height)];
    [self addSubview:imageCarouseControl];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    [imageCarouseControl addSubview:imageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, width, 30)];
    [titleLabel setBackgroundColor:UIColorFromRGBA(154,154, 154, 0.5)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [imageCarouseControl addSubview:titleLabel];
    [imageCarouseControl bringSubviewToFront:titleLabel];
}

@end

