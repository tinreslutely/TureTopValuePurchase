//
//  MDHomeRedShopTableViewCell.m
//  TureTopValuePurchaseDemo
//  首页-推荐店铺视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeRedShopTableViewCell.h"

@implementation MDHomeRedShopTableViewCell

@synthesize titleLabel,imageScrollView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<ImageCarouselViewDelegate>)delegate{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self bringRMShopCellWidthDelegate:delegate];
    }
    return self;
}

/**
 *  生成一个包含一个导航标题、一个轮播控件的UITableViewCell
 *  用于铭道好店模块
 *
 *  @param delegate ImageCarouselView协议
 *
 */
-(void)bringRMShopCellWidthDelegate:(id<ImageCarouselViewDelegate>)delegate{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    //添加一个导航标题
    UIView *navView = [[UIView alloc] init];
    [self addSubview: navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).with.offset(8);
        make.right.equalTo(navView.mas_right).with.offset(8);
        make.centerY.equalTo(navView);
        make.height.mas_equalTo(30);
    }];
    
    imageScrollView = [[ImageCarouselView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    [imageScrollView setBackgroundColor:[UIColor whiteColor]];
    imageScrollView.infiniteLoop = YES;
    imageScrollView.pageControlStyle = ImageCarouselViewPageContolStyleAnimated;
    imageScrollView.showPageControl = NO;
    imageScrollView.delegate = delegate;
    [self addSubview:imageScrollView];
}
@end
