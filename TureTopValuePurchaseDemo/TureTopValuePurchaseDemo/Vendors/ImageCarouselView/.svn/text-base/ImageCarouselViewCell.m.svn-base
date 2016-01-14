//
//  ImageCarouselViewCell.m
//  SDCycleScrollView
//
//  Created by 李晓毅 on 15/12/1.
//  Copyright © 2015年 GSD. All rights reserved.
//

#import "ImageCarouselViewCell.h"

@implementation ImageCarouselViewCell
{
    __weak UILabel *_titleLabel;
}


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
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(pointX, 0, width, self.frame.size.height)];
    [self addSubview:control];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    [imageView setTag:1001];
    [control addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, width, 30)];
    [label setTag:1002];
    [label setBackgroundColor:UIColorFromRGBA(154,154, 154, 0.5)];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [control addSubview:label];
    [control bringSubviewToFront:label];
}

@end

