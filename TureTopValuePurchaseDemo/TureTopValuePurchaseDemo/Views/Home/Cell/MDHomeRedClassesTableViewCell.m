//
//  MDHomeRedClassesTableViewCell.m
//  TureTopValuePurchaseDemo
//  首页-广告功能视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeRedClassesTableViewCell.h"

@implementation MDHomeRedClassesTableViewCell

@synthesize navTitleLabel,bannerButtonView,productsView;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageHeight:(float)imageHeight proImageHeight:(float)proImageHeight target:(_Nullable id)target rmMoreAction:(SEL)rmMoreAction rmImageAction:(SEL)rmImageAction rmProductDetailAction:(SEL)rmProductDetailAction{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self bringProductRecommendForCellWithImageHeight:imageHeight proImageHeight:proImageHeight target:target rmMoreAction:rmMoreAction rmImageAction:rmImageAction rmProductDetailAction:rmProductDetailAction];
    }
    return self;
}

/**
 *  生成一个包含导航标题和一个按钮图片轮播控件的UITableViewCell
 *  用于铭道好店模块
 *  @param identifier cell的identifier
 *
 *  @return UITableViewCell
 */
-(void)bringProductRecommendForCellWithImageHeight:(float)imageHeight proImageHeight:(float)proImageHeight target:(_Nullable id)target rmMoreAction:(SEL)rmMoreAction rmImageAction:(SEL)rmImageAction rmProductDetailAction:(SEL)rmProductDetailAction{
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
    
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setImage:[UIImage imageNamed:@"arrow_right_b"] forState:UIControlStateNormal];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(5, 70, 5, 0)];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreButton addTarget:target action:rmMoreAction forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView.mas_right).with.offset(-8);
        make.centerY.equalTo(navView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    navTitleLabel = [[UILabel alloc] init];
    [navTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [navView addSubview:navTitleLabel];
    [navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).with.offset(8);
        make.right.equalTo(moreButton.mas_left).with.offset(8);
        make.centerY.equalTo(navView);
        make.height.mas_equalTo(30);
    }];
    
    //添加一个图片
    bannerButtonView = [[UIButton alloc] init];
    [bannerButtonView addTarget:target action:rmImageAction forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: bannerButtonView];
    [bannerButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(imageHeight);
        make.top.equalTo(navView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    //添加一个推荐产品行
    productsView = [[UIView alloc] init];
    [self addSubview: productsView];
    [productsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerButtonView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    float width = SCREEN_WIDTH/3;
    float point_x = 0;
    UIButton *productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, proImageHeight)];
    [productButton addTarget:target action:rmProductDetailAction forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    point_x += width;
    productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, proImageHeight)];
    [productButton addTarget:target action:rmProductDetailAction forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    point_x += width;
    productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, proImageHeight)];
    [productButton addTarget:target action:rmProductDetailAction forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
}

@end
